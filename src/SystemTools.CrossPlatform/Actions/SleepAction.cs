using ClassIsland.Core.Abstractions.Automation;
using ClassIsland.Core.Attributes;
using ClassIsland.Platforms.Abstraction;
using Microsoft.Extensions.Logging;
using System;
using System.Threading.Tasks;
using SystemTools.CrossPlatform.Services;

namespace SystemTools.CrossPlatform.Actions;

// ============================================================================
// p2-01 B10 睡眠（源锚点 E:\My Github Projects\SystemTools\Actions\SleepAction.cs）
// ============================================================================
// - ActionInfo :10；Windows 命令启动 :21-30（随源 rundll32 形态保持，尚书省裁决 1）
//   → 统一由 Actions\SystemPowerCommand.cs（运行期分派）承载（B 档「Windows 专属点」声明位，04-spec.md:61；
//   R-2 CONDITIONAL 口径，本文件零门禁符号）。
// - 无设置控件对（源 Plugin.cs:382 单参注册形态，p2-05 §1.2）。
// - U4（04-spec.md:90）：以命令退出结果作为成功依据（06 条目 43）；目标平台电源调用为同步语义，
//   有界等待超时按“已发起、未阻塞确认”处理（适配注记 D-8，证据 p2-01 §3），不发失败提示、
//   不伪造成功通知；其余失败经 IDesktopToastService 降级提示并正常返回，不抛未处理异常。
// - 06 条目 43 表述中的宿主 ISystemPowerService 双分支 ABSENT（p2-05 §4）→ 插件本地实现。
// ============================================================================
[ActionInfo("SystemTools.CrossPlatform.Sleep", "睡眠", "\uF44B", false)]
public class SleepAction(ILogger<SleepAction> logger) : ActionBase
{
    // 执行器返回约定：-1 = 启动失败；-2 = 有界等待超时（未确认）。
    private const int StartFailedExitCode = -1;

    private readonly ILogger<SleepAction> _logger = logger;

    protected override async Task OnInvoke()
    {
        _logger.LogDebug("SleepAction OnInvoke 开始");

        if (!OperatingSystem.IsWindows())
        {
            _logger.LogWarning("睡眠预检未通过：当前平台非 Windows，按 U4 降级跳过执行。");
            await NotifyDegradedAsync("睡眠", "睡眠在当前平台不可用，已跳过执行");
            await base.OnInvoke();
            return;
        }

        if (!SystemPowerCommand.IsRundll32CommandAvailable())
        {
            _logger.LogWarning("睡眠预检未通过：系统命令不可用，按 U4 降级跳过执行。");
            await NotifyDegradedAsync("睡眠", "睡眠命令不可用，已跳过执行");
            await base.OnInvoke();
            return;
        }

        var exitCode = SystemPowerCommand.RunSleep();
        if (exitCode == StartFailedExitCode)
        {
            _logger.LogError("睡眠未执行（exit={ExitCode}）。", exitCode);
            await NotifyDegradedAsync("睡眠", "睡眠未执行");
            await base.OnInvoke();
            return;
        }

        if (exitCode < 0)
        {
            // 有界等待超时：电源调用已发起、进程尚未返回（同步语义），按已发起处理，
            // 不发失败提示也不发成功通知（U4：不做未经确认的成功宣称）。
            _logger.LogInformation("睡眠命令已发起（有界等待超时，未阻塞确认；exit={ExitCode}）。", exitCode);
            await base.OnInvoke();
            return;
        }

        if (exitCode != 0)
        {
            _logger.LogError("睡眠未执行（exit={ExitCode}）。", exitCode);
            await NotifyDegradedAsync("睡眠", "睡眠未执行");
            await base.OnInvoke();
            return;
        }

        _logger.LogInformation("已执行睡眠命令");

        await base.OnInvoke();
        _logger.LogDebug("SleepAction OnInvoke 完成");
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