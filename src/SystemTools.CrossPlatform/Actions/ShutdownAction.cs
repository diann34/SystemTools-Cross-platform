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
// p2-01 B4 计时关机（源锚点 E:\My Github Projects\SystemTools\Actions\ShutdownAction.cs）
// ============================================================================
// - ActionInfo :15；Windows 命令启动 :30-38 → 统一由 Actions\SystemPowerCommand.cs 承载
//   （B 档「Windows 专属点」声明位，04-spec.md:61；R-2 CONDITIONAL 口径，本文件零门禁符号）。
// - Windows 命令启动经统一执行器 Actions\SystemPowerCommand.cs（运行期分派）；源 :40-44 的
//   WinForms 按键模拟确认按 06 条目 37 删除；ShowPrompt 成员保留随源配置兼容，
//   不承诺各 OS 相同的系统确认 UI（06 条目 37 拟纳入边界）。
// - U4（04-spec.md:90）：执行前运行时 OS/能力预检；非 Windows 或预检/执行失败 →
//   IDesktopToastService 降级提示（双分支 PRESENT，p2-05 §4）并正常返回，不抛未处理异常。
// - 06 条目 37 表述中的宿主 ISystemPowerService 双分支 ABSENT（p2-05 §4）→ 电源执行器为
//   插件本地实现（SystemTools.CrossPlatform.Actions），证据登记该偏差注记。
// ============================================================================
[ActionInfo("SystemTools.CrossPlatform.Shutdown", "计时关机", "\uE4C4", false)]
public class ShutdownAction(ILogger<ShutdownAction> logger) : ActionBase<ShutdownSettings>
{
    private readonly ILogger<ShutdownAction> _logger = logger;

    protected override async Task OnInvoke()
    {
        _logger.LogDebug("ShutdownAction OnInvoke 开始");

        if (Settings == null) return;

        if (Settings.Seconds < 0) return;

        // U4 预检 1：运行时 OS 预检（04-spec:76 允许的运行时守卫分支形态）。
        if (!OperatingSystem.IsWindows())
        {
            _logger.LogWarning("计时关机预检未通过：当前平台非 Windows，按 U4 降级跳过执行。");
            await NotifyDegradedAsync("计时关机", "计时关机在当前平台不可用，已跳过执行");
            await base.OnInvoke();
            return;
        }

        // U4 预检 2：命令能力预检（存在性检查，不触发电源动作）。
        if (!SystemPowerCommand.IsShutdownCommandAvailable())
        {
            _logger.LogWarning("计时关机预检未通过：系统命令不可用，按 U4 降级跳过执行。");
            await NotifyDegradedAsync("计时关机", "计时关机命令不可用，已跳过执行");
            await base.OnInvoke();
            return;
        }

        var exitCode = SystemPowerCommand.RunTimedShutdown(Settings.Seconds);
        if (exitCode != 0)
        {
            // U4：命令未接受 → 降级提示并正常返回，不抛未处理异常、不发未确认的成功通知。
            _logger.LogError("计时关机命令未被执行（exit={ExitCode}）。", exitCode);
            await NotifyDegradedAsync("计时关机", "计时关机命令未被执行");
            await base.OnInvoke();
            return;
        }

        _logger.LogInformation("已执行计时关机命令（{Seconds} 秒）。", Settings.Seconds);
        if (Settings.NotifyOnExecute)
            IAppHost.GetService<SystemToolsNotificationProvider>()?.ShowNotification(new NotificationRequest
            {
                MaskContent = NotificationContent.CreateTwoIconsMask("已执行计时关机", "\uE9FB", "")
            });

        await base.OnInvoke();
    }

    // U4 降级通知（预检失败静默或 toast 提示，按已批口径二者取 toast；toast 自身失败仅记日志）。
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