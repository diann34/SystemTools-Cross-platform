using ClassIsland.Core.Abstractions.Automation;
using ClassIsland.Core.Attributes;
using Microsoft.Extensions.Logging;
using System;
using System.Diagnostics;
using System.Threading.Tasks;
using SystemTools.CrossPlatform.Services;
using SystemTools.CrossPlatform.Settings;
using ClassIsland.Core.Models.Notification;
using ClassIsland.Shared;

namespace SystemTools.CrossPlatform.Actions;

[ActionInfo("SystemTools.CrossPlatform.KillProcess", "退出进程", "\uE0DE", false)]
public class KillProcessAction(ILogger<KillProcessAction> logger) : ActionBase<KillProcessSettings>
{
    private readonly ILogger<KillProcessAction> _logger = logger;

    protected override async Task OnInvoke()
    {
        _logger.LogDebug("KillProcessAction OnInvoke 开始");

        if (Settings == null || string.IsNullOrWhiteSpace(Settings.ProcessName))
        {
            _logger.LogWarning("进程名为空");
            return;
        }


        var processName = Settings.ProcessName.Trim();
        if (processName.EndsWith(".exe", StringComparison.OrdinalIgnoreCase))
        {
            processName = processName[..^4]; //等价于processName.Remove(processName.Length - 4)
        }

        _logger.LogInformation("正在终止进程: {ProcessName}", processName);
        Process[] pses;
        try
        {
            pses = Process.GetProcessesByName(processName);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "获取相关联的进程列表失败");
            throw;
        }
        foreach (var ps in pses)
        {
            try
            {
                ps.Kill();
            }
            catch(Exception ex)
            {
                _logger.LogError(ex, "终止进程 {ProcessName} (PID: {PID}) 失败", ps.ProcessName, ps.Id);
                continue;
            }
        }

        if (Settings.NotifyOnExecute)
            IAppHost.GetService<SystemToolsNotificationProvider>()?.ShowNotification(new NotificationRequest
            {
                MaskContent = NotificationContent.CreateTwoIconsMask("已执行退出进程操作", "\uE9FB", "")
            });


        await base.OnInvoke();
        _logger.LogDebug("KillProcessAction OnInvoke 完成");
    }
}
