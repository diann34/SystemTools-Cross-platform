using ClassIsland.Core.Abstractions.Automation;
using ClassIsland.Core.Attributes;
using ClassIsland.Core.Models.Notification;
using ClassIsland.Platforms.Abstraction;
using ClassIsland.Shared;
using Microsoft.Extensions.Logging;
using System;
using System.Threading.Tasks;
using SystemTools.CrossPlatform.Services;
using SystemTools.CrossPlatform.Settings;

namespace SystemTools.CrossPlatform.Actions;

// ============================================================================
// p2-01 B6 取消关机计划（源锚点 E:\My Github Projects\SystemTools\Actions\CancelShutdownAction.cs）
// ============================================================================
// - ActionInfo :14；Windows 命令启动 :27-36（/a 随源）→ 统一由 Actions\SystemPowerCommand.cs（运行期分派）承载
//   （B 档「Windows 专属点」声明位，04-spec.md:61；R-2 CONDITIONAL 口径，本文件零门禁符号）。
// - 设置对=共享 ShortcutKeyNotificationSettings(+Control)（p1-03 共享交付，仅引用不复制，p2-05 §1.2）。
// - U4（04-spec.md:90）：预检 + 失败经 IDesktopToastService 降级提示；按 06 条目 39 区分
//   「没有活动计划」与「取消失败」（退出码 1116 = 系统命令“无活动关机计划”语义）。
// - 06 条目 39 表述中的宿主 ISystemPowerService 双分支 ABSENT（p2-05 §4）→ 插件本地实现。
// ============================================================================
[ActionInfo("SystemTools.CrossPlatform.CancelShutdown", "取消关机计划", "\uE4CC", false)]
public class CancelShutdownAction(ILogger<CancelShutdownAction> logger) : ActionBase<ShortcutKeyNotificationSettings>
{
    // 系统取消命令“当前无活动关机计划”退出码（06 条目 39 的语义区分依据）。
    private const int NoShutdownInProgressExitCode = 1116;

    private readonly ILogger<CancelShutdownAction> _logger = logger;

    protected override async Task OnInvoke()
    {
        _logger.LogDebug("CancelShutdownAction OnInvoke 开始");

        if (!OperatingSystem.IsWindows())
        {
            _logger.LogWarning("取消关机计划预检未通过：当前平台非 Windows，按 U4 降级跳过执行。");
            await NotifyDegradedAsync("取消关机计划", "取消关机计划在当前平台不可用，已跳过执行");
            await base.OnInvoke();
            return;
        }

        if (!SystemPowerCommand.IsShutdownCommandAvailable())
        {
            _logger.LogWarning("取消关机计划预检未通过：系统命令不可用，按 U4 降级跳过执行。");
            await NotifyDegradedAsync("取消关机计划", "取消关机计划命令不可用，已跳过执行");
            await base.OnInvoke();
            return;
        }

        _logger.LogInformation("正在执行取消关机命令");
        var exitCode = SystemPowerCommand.RunCancelScheduledShutdown();
        if (exitCode == 0)
        {
            _logger.LogInformation("关机已取消");
        }
        else if (exitCode == NoShutdownInProgressExitCode)
        {
            // 06 条目 39：区分“没有活动计划”（非失败）与“取消失败”。
            _logger.LogInformation("当前没有活动的关机计划（exit={ExitCode}），无计划可取消。", exitCode);
            await NotifyDegradedAsync("取消关机计划", "当前没有活动的关机计划");
            await base.OnInvoke();
            return;
        }
        else
        {
            _logger.LogError("取消关机失败（exit={ExitCode}）。", exitCode);
            await NotifyDegradedAsync("取消关机计划", "取消关机计划未执行成功");
            await base.OnInvoke();
            return;
        }

        if (Settings.NotifyOnExecute)
            IAppHost.GetService<SystemToolsNotificationProvider>()?.ShowNotification(new NotificationRequest
            {
                MaskContent = NotificationContent.CreateTwoIconsMask("已取消关机计划", "\uE9FB", "")
            });

        await base.OnInvoke();
        _logger.LogDebug("CancelShutdownAction OnInvoke 完成");
    }

    private async Task NotifyDegradedAsync(string title, string reason)
    {
        try
        {
            await PlatformServices.DesktopToastService.ShowToastAsync($"SystemTools - {title}", reason);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "降级提示发送失败：{Title} - {Reason}", title, reason);
        }
    }
}