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
// p2-01 B7 锁定屏幕（源锚点 E:\My Github Projects\SystemTools\Actions\LockScreenAction.cs）
// ============================================================================
// - ActionInfo :14；Windows 命令启动 :27-36（随源 rundll32 形态保持，尚书省裁决 1）
//   → 统一由 Actions\SystemPowerCommand.cs（运行期分派）承载（B 档「Windows 专属点」声明位，04-spec.md:61；
//   R-2 CONDITIONAL 口径，本文件零门禁符号）。
// - 设置对=共享 ShortcutKeyNotificationSettings(+Control)（p1-03 共享交付，仅引用不复制，p2-05 §1.2）。
// - U4（04-spec.md:90）：成功判定以命令退出状态为准，不以进程启动即视为锁定（06 条目 40）；
//   失败经 IDesktopToastService 降级提示并正常返回，不抛未处理异常。
// - 06 条目 40 表述中的宿主 ISystemPowerService 双分支 ABSENT（p2-05 §4）→ 插件本地实现。
// ============================================================================
[ActionInfo("SystemTools.CrossPlatform.LockScreen", "锁定屏幕", "\uEAF0", false)]
public class LockScreenAction(ILogger<LockScreenAction> logger) : ActionBase<ShortcutKeyNotificationSettings>
{
    private readonly ILogger<LockScreenAction> _logger = logger;

    protected override async Task OnInvoke()
    {
        _logger.LogDebug("LockScreenAction OnInvoke 开始");

        if (!OperatingSystem.IsWindows())
        {
            _logger.LogWarning("锁定屏幕预检未通过：当前平台非 Windows，按 U4 降级跳过执行。");
            await NotifyDegradedAsync("锁定屏幕", "锁定屏幕在当前平台不可用，已跳过执行");
            await base.OnInvoke();
            return;
        }

        if (!SystemPowerCommand.IsRundll32CommandAvailable())
        {
            _logger.LogWarning("锁定屏幕预检未通过：系统命令不可用，按 U4 降级跳过执行。");
            await NotifyDegradedAsync("锁定屏幕", "锁定屏幕命令不可用，已跳过执行");
            await base.OnInvoke();
            return;
        }

        _logger.LogInformation("正在执行锁定屏幕命令");
        var exitCode = SystemPowerCommand.RunLockWorkstation();
        if (exitCode != 0)
        {
            _logger.LogError("锁定屏幕未执行（exit={ExitCode}）。", exitCode);
            await NotifyDegradedAsync("锁定屏幕", "锁定屏幕未执行");
            await base.OnInvoke();
            return;
        }

        _logger.LogInformation("屏幕已锁定");
        if (Settings.NotifyOnExecute)
            IAppHost.GetService<SystemToolsNotificationProvider>()?.ShowNotification(new NotificationRequest
            {
                MaskContent = NotificationContent.CreateTwoIconsMask("已锁定屏幕", "\uE9FB", "")
            });

        await base.OnInvoke();
        _logger.LogDebug("LockScreenAction OnInvoke 完成");
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