using ClassIsland.Core.Abstractions.Automation;
using ClassIsland.Core.Attributes;
using ClassIsland.Platforms.Abstraction;
using Microsoft.Extensions.Logging;
using System;
using System.Threading.Tasks;
using SystemTools.CrossPlatform.Services;

namespace SystemTools.CrossPlatform.Actions;

// ============================================================================
// p2-01 B9 立即关机（源锚点 E:\My Github Projects\SystemTools\Actions\ImmediateShutdownAction.cs）
// ============================================================================
// - ActionInfo :12；源 :16-17 ntdll RtlAdjustPrivilege + :28 ExitWindowsEx（CsWin32，不公开 API）
//   → 按尚书省裁决 1 改为命令等价（/s /t 0），实现统一由 Actions\SystemPowerCommand.cs（运行期分派）承载
//   （B 档「Windows 专属点」声明位，04-spec.md:61；R-2 CONDITIONAL 口径，本文件零门禁符号）。
// - 无设置控件对（源 Plugin.cs:381 单参注册形态，p2-05 §1.2）。
// - U4（04-spec.md:90）：预检 + 失败经 IDesktopToastService 通知未执行并记录原因，正常返回
//   且不抛未处理异常；命令启动但退出失败时同样不发成功通知（06 条目 42）。
// - 06 条目 42 表述中的宿主 ISystemPowerService 双分支 ABSENT（p2-05 §4）→ 插件本地实现。
// ============================================================================
[ActionInfo("SystemTools.CrossPlatform.ImmediateShutdown", "立即关机", "\uEDE9", false)]
public class ImmediateShutdownAction(ILogger<ImmediateShutdownAction> logger) : ActionBase
{
    private readonly ILogger<ImmediateShutdownAction> _logger = logger;

    protected override async Task OnInvoke()
    {
        _logger.LogDebug("ImmediateShutdownAction OnInvoke 开始");

        if (!OperatingSystem.IsWindows())
        {
            _logger.LogWarning("立即关机预检未通过：当前平台非 Windows，按 U4 降级跳过执行。");
            await NotifyDegradedAsync("立即关机", "立即关机在当前平台不可用，已跳过执行");
            await base.OnInvoke();
            return;
        }

        if (!SystemPowerCommand.IsShutdownCommandAvailable())
        {
            _logger.LogWarning("立即关机预检未通过：系统命令不可用，按 U4 降级跳过执行。");
            await NotifyDegradedAsync("立即关机", "立即关机命令不可用，已跳过执行");
            await base.OnInvoke();
            return;
        }

        var exitCode = SystemPowerCommand.RunImmediateShutdown();
        if (exitCode != 0)
        {
            _logger.LogError("立即关机未执行（exit={ExitCode}）。", exitCode);
            await NotifyDegradedAsync("立即关机", "立即关机未执行");
            await base.OnInvoke();
            return;
        }

        _logger.LogInformation("已执行立即关机命令");

        await base.OnInvoke();
        _logger.LogDebug("ImmediateShutdownAction OnInvoke 完成");
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