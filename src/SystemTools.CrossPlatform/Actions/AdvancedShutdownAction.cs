using Avalonia;
using Avalonia.Controls;
using Avalonia.Layout;
using Avalonia.Threading;
using ClassIsland.Core.Abstractions.Automation;
using ClassIsland.Core.Attributes;
using ClassIsland.Platforms.Abstraction;
using Microsoft.Extensions.Logging;
using System;
using System.Threading;
using System.Threading.Tasks;
using Avalonia.Animation;
using Avalonia.Animation.Easings;
using Avalonia.Controls.Primitives;
using Avalonia.Media;
using Avalonia.Styling;
using SystemTools.CrossPlatform.Services;
using SystemTools.CrossPlatform.Settings;
using SystemTools.CrossPlatform.Views;

namespace SystemTools.CrossPlatform.Actions;

// ============================================================================
// p2-01 B5 高级计时关机（源锚点 E:\My Github Projects\SystemTools\Actions\AdvancedShutdownAction.cs）
// ============================================================================
// 本行动全部 Windows 命令启动（计划/取消/立即关机）统一由 Actions\SystemPowerCommand.cs
// 执行器承载（单一 net10.0 产物，运行期平台分派）。
//
// 已批机制适配点（尚书省裁决 1 + 06 条目 38，逐条留痕于证据 p2-01 §3）：
//  1. 计划载体：源 :156-180 经系统命令解释器包装倒计时进程（cmd 倒计时 + 到点关机），改为
//     「先取消旧计划 + 直接按总秒数计划」的系统命令族形态（Windows 仅允许单一关机计划；
//     源本地进程 kill 语义的等价改写，无本地倒计时进程可跟踪）。
//  2. 看门狗：源 :25/:77-87 固定宿主进程名轮询 + :256-291 计划活性轮询，按 06 条目 38
//     「看门狗改用宿主生命周期事件，不检查固定 .exe 名称」移除；宿主退出路径由礼部生命周期
//     接线调用 CancelPlanOnAppStopping(bool) 承担（源 Plugin.cs:1048 先例；p2-05 §1.2 非计数附属行）。
//  3. 取消可见性：源 :201-219 TryAbortSystemShutdown 吞异常，按 06 条目 38「吞异常不能掩盖未取消」
//     修订为记录退出码 + 用户取消路径失败提示。
//  4. 立即关机按钮：源 :388-406 进程启动 + 仅记日志，改为执行器退出码判定 + 失败 Toast（U4）。
//  5. 静态取消路径（CancelPlanOnAppStopping，源 :40-54）保留静态 bool 契约；类改用经典构造函数
//     以缓存静态 logger（静态方法无法访问主构造函数参数，可观测性适配）。
//  6. UI（对话框/悬浮窗/动画/倒计时文本）随源逐行保留；MyWindow/FluentIcon 为双分支 PRESENT 宿主类型。
//  7. U4（04-spec.md:90）：执行前运行时 OS/能力预检；预检/执行失败经 IDesktopToastService 降级提示
//     并正常结束行动（await base.OnInvoke()），不抛未处理异常。
// ============================================================================
[ActionInfo("SystemTools.CrossPlatform.AdvancedShutdown", "高级计时关机", "\uE4D2", false)]
public class AdvancedShutdownAction : ActionBase<AdvancedShutdownSettings>
{
    // 系统取消命令“当前无活动关机计划”退出码（B6/B5 共用语义，非失败）。
    private const int NoShutdownInProgressExitCode = 1116;

    // 执行器返回约定：-1 = 启动失败；-2 = 有界等待超时（未确认）。
    private const int StartFailedExitCode = -1;

    // 静态取消路径的可观测性：静态方法无法访问主构造函数 logger，构造时缓存（适配点 5）。
    private static ILogger? _sharedLogger;

    private readonly ILogger<AdvancedShutdownAction> _logger;

    private static readonly object StateLock = new();
    private static DateTimeOffset _shutdownAt = DateTimeOffset.MinValue;
    private static int _totalScheduledSeconds;
    private static AdvancedShutdownDialog? _activeDialog;
    private static Window? _floatingWindow;
    private static bool _allowMainDialogClose;
    private static bool _allowFloatingWindowClose;
    private static int _appStoppingHandled;

    public AdvancedShutdownAction(ILogger<AdvancedShutdownAction> logger)
    {
        _logger = logger;
        _sharedLogger = logger;
    }

    /// <summary>
    /// 宿主生命周期接线入口（礼部按源 Plugin.cs:1048 形态在 AppStopping 调用；p2-05 §1.2：
    /// 本静态方法仅收 bool，与 p2-03 SystemShutdownMonitor 文件无编译耦合）。首次调用返回 true。
    /// </summary>
    public static bool CancelPlanOnAppStopping(bool isSessionEnding)
    {
        if (Interlocked.Exchange(ref _appStoppingHandled, 1) != 0)
        {
            return false;
        }

        if (!isSessionEnding)
        {
            // 宿主主动退出（非系统关机/注销）：取消系统关机计划；结果记日志，不吞“未取消”（适配点 3）。
            var abortCode = SystemPowerCommand.RunCancelScheduledShutdown();
            _sharedLogger?.LogInformation("宿主退出取消关机计划：exit={ExitCode}（无活动计划时属预期）。", abortCode);
        }

        return true;
    }

    protected override async Task OnInvoke()
    {
        _logger.LogDebug("AdvancedShutdownAction OnInvoke 开始");

        // U4 预检 1：运行时 OS/能力预检（04-spec:76 允许的运行时守卫分支形态）。
        if (!OperatingSystem.IsWindows() || !SystemPowerCommand.IsShutdownCommandAvailable())
        {
            _logger.LogWarning("高级计时关机预检未通过（平台或命令能力不可用），按 U4 降级跳过执行。");
            await NotifyDegradedAsync("高级计时关机", "高级计时关机在当前环境不可用，已跳过执行");
            await base.OnInvoke();
            return;
        }

        if (!IsPlanActive())
        {
            var configuredMinutes = Math.Max(1, Settings?.Minutes ?? 2);
            if (!ScheduleShutdown(configuredMinutes))
            {
                // 06 条目 38：系统动作不可用 → Toast 通知失败原因，正常结束行动。
                await NotifyDegradedAsync("高级计时关机", "计划关机命令未被执行");
                await base.OnInvoke();
                return;
            }
        }

        await ShowDialogAsync();
        await base.OnInvoke();
    }

    private static bool IsPlanActive()
    {
        lock (StateLock)
        {
            return _shutdownAt > DateTimeOffset.Now;
        }
    }

    private bool ScheduleShutdown(int minutes)
    {
        var safeMinutes = Math.Max(1, minutes);
        var seconds = safeMinutes * 60;

        // 适配点 1：先取消旧计划再计划（系统仅允许单一关机计划；无旧计划时取消返回非零仅记日志，
        // 不影响后续计划；源本地倒计时进程 kill 语义的等价改写）。
        var abortCode = SystemPowerCommand.RunCancelScheduledShutdown();
        _logger.LogDebug("计划前取消旧计划：exit={ExitCode}", abortCode);

        var scheduleCode = SystemPowerCommand.RunTimedShutdown(seconds);
        if (scheduleCode != 0)
        {
            _logger.LogError("计划关机命令未被执行（exit={ExitCode}）。秒数: {Seconds}", scheduleCode, seconds);
            return false;
        }

        lock (StateLock)
        {
            _shutdownAt = DateTimeOffset.Now.AddMinutes(safeMinutes);
            _totalScheduledSeconds = seconds;
        }

        _logger.LogInformation("已计划 {Seconds} 秒后执行关机。", seconds);
        return true;
    }

    void AssignProgressAnimator(ProgressBar bar, TimeSpan targetTime, TimeSpan totalTime)
    {
        new Animation
        {
            Children =
            {
                new KeyFrame
                {
                    Cue = new Cue(0),
                    Setters =
                    {
                        new Setter(RangeBase.ValueProperty, 3000.0 * targetTime.TotalMilliseconds / totalTime.TotalMilliseconds)
                    }
                },
                new KeyFrame
                {
                    Cue = new Cue(1),
                    Setters =
                    {
                        new Setter(RangeBase.ValueProperty, 0.0),
                    }
                }
            },
            Duration = targetTime,
            FillMode = FillMode.Forward
        }.RunAsync(bar);
    }

    private bool ExtendShutdown(int extendMinutes)
    {
        var safeExtendMinutes = Math.Max(1, extendMinutes);
        DateTimeOffset previousTargetTime;
        int previousTotalSeconds;
        DateTimeOffset targetTime;

        lock (StateLock)
        {
            previousTargetTime = _shutdownAt;
            previousTotalSeconds = _totalScheduledSeconds;
            var baseline = _shutdownAt > DateTimeOffset.Now ? _shutdownAt : DateTimeOffset.Now;
            _shutdownAt = baseline.AddMinutes(safeExtendMinutes);
            targetTime = _shutdownAt;
            _totalScheduledSeconds = (int)Math.Ceiling((targetTime - DateTimeOffset.Now).TotalSeconds);
        }

        var totalSeconds = (int)Math.Ceiling((targetTime - DateTimeOffset.Now).TotalSeconds);
        totalSeconds = Math.Max(60, totalSeconds);

        // 适配点 1：与 ScheduleShutdown 同一命令族语义——先取消旧计划再按延长后的总秒数重计划。
        var abortCode = SystemPowerCommand.RunCancelScheduledShutdown();
        _logger.LogDebug("延长重计划前取消旧计划：exit={ExitCode}", abortCode);

        var scheduleCode = SystemPowerCommand.RunTimedShutdown(totalSeconds);
        if (scheduleCode != 0)
        {
            _logger.LogError("延长后的计划关机命令未被执行（exit={ExitCode}），总秒数: {Seconds}", scheduleCode, totalSeconds);
            return false;
        }

        _logger.LogInformation("已延长关机计划，目标时间 {TargetTime:HH:mm:ss}（{Seconds} 秒）。", targetTime, totalSeconds);
        return true;
    }

    private void CancelShutdownPlan()
    {
        var hadPlan = IsPlanActive();
        var abortCode = StopAllStates();
        if (!hadPlan)
        {
            return;
        }

        if (abortCode == 0)
        {
            _logger.LogInformation("关机计划已取消。");
        }
        else if (abortCode == NoShutdownInProgressExitCode)
        {
            _logger.LogInformation("取消时已无活动关机计划（exit={ExitCode}，可能已被外部取消）。", abortCode);
        }
        else
        {
            // 适配点 3：06 条目 38——取消失败不得被吞掉，记录并提示用户。
            _logger.LogWarning("取消关机计划未生效（exit={ExitCode}）。", abortCode);
            _ = NotifyDegradedAsync("取消关机计划", "取消关机计划未生效，请检查系统关机计划状态");
        }
    }

    /// <summary>取消系统关机计划并回收本地计划状态/窗口/定时器；返回取消命令退出码（适配点 1/3）。</summary>
    private int StopAllStates()
    {
        var abortCode = SystemPowerCommand.RunCancelScheduledShutdown();
        if (abortCode == 0)
        {
            _logger.LogInformation("已取消系统关机计划。");
        }
        else
        {
            _logger.LogInformation("取消系统关机计划返回非零（exit={ExitCode}；无活动计划时属预期）。", abortCode);
        }

        lock (StateLock)
        {
            _shutdownAt = DateTimeOffset.MinValue;
            _totalScheduledSeconds = 0;
        }

        Dispatcher.UIThread.Post(() =>
        {
            CloseMainDialogProgrammatically();
            CloseFloatingWindowProgrammatically();
        });

        return abortCode;
    }

    private static int GetRemainingSeconds()
    {
        lock (StateLock)
        {
            var remainingSeconds = (int)Math.Ceiling((_shutdownAt - DateTimeOffset.Now).TotalSeconds);
            return Math.Max(0, remainingSeconds);
        }
    }

    private static double BuildCountdownProgress()
    {
        int remaining;
        int total;
        lock (StateLock)
        {
            remaining = Math.Max(0, (int)Math.Ceiling((_shutdownAt - DateTimeOffset.Now).TotalSeconds));
            total = _totalScheduledSeconds;
        }

        if (total <= 0)
        {
            return 0;
        }

        return Math.Clamp(remaining * 100.0 / total, 0, 100);
    }

    private static string BuildCountdownText()
    {
        var remainingSeconds = GetRemainingSeconds();
        var minutes = remainingSeconds / 60;
        var seconds = remainingSeconds % 60;
        return $"距离关机还有{minutes}分{seconds:00}秒";
    }

    private async Task ShowDialogAsync()
    {
        await Dispatcher.UIThread.InvokeAsync(async () =>
        {
            CloseFloatingWindowProgrammatically();
            await ShowStyledDialogAsync();
        });
    }

    private async Task ShowStyledDialogAsync()
    {
        if (_activeDialog is { IsVisible: true })
        {
            _activeDialog.Activate();
            return;
        }

        var dialog = new AdvancedShutdownDialog
        {
            CanResize = false
        };
        _activeDialog = dialog;

        dialog.Closing += (_, e) =>
        {
            if (!_allowMainDialogClose && IsPlanActive())
            {
                e.Cancel = true;
            }
        };

        var textBlock = dialog.CountdownTextBlock ?? throw new InvalidOperationException("CountdownTextBlockElement 未找到");
        var progressBar = dialog.CountdownProgressBar ?? throw new InvalidOperationException("CountdownProgressBarElement 未找到");
        var immediateShutdownButton = dialog.ImmediateShutdownButton ?? throw new InvalidOperationException("ImmediateShutdownButtonElement 未找到");
        var readButton = dialog.ReadButton ?? throw new InvalidOperationException("ReadButtonElement 未找到");
        var cancelPlanButton = dialog.CancelPlanButton ?? throw new InvalidOperationException("CancelPlanButtonElement 未找到");
        var extendButton = dialog.ExtendButton ?? throw new InvalidOperationException("ExtendButtonElement 未找到");

        textBlock.Text = BuildCountdownText();
        progressBar.Value = BuildCountdownProgress();

        var countdownTimer = new DispatcherTimer { Interval = TimeSpan.FromSeconds(1) };
        countdownTimer.Tick += (_, _) =>
        {
            textBlock.Text = BuildCountdownText();
            //progressBar.Value = BuildCountdownProgress();

            if (!IsPlanActive())
            {
                CloseMainDialogProgrammatically();
            }
        };
        AssignProgressAnimator(progressBar, _shutdownAt - DateTimeOffset.Now, TimeSpan.FromSeconds(_totalScheduledSeconds));
        countdownTimer.Start();

        dialog.Closed += (_, _) =>
        {
            countdownTimer.Stop();
            if (ReferenceEquals(_activeDialog, dialog))
            {
                _activeDialog = null;
            }

            if (IsPlanActive())
            {
                ShowOrUpdateFloatingWindow();
            }
        };

        readButton.Click += (_, _) =>
        {
            CloseMainDialogProgrammatically();
            ShowOrUpdateFloatingWindow();
        };

        immediateShutdownButton.Click += (_, _) =>
        {
            StopAllStates();
            var exitCode = SystemPowerCommand.RunImmediateShutdown();
            if (exitCode != 0)
            {
                // 适配点 4：U4——立即关机失败经 Toast 降级提示，不再静默。
                _logger.LogError("执行立即关机失败（exit={ExitCode}）。", exitCode);
                _ = NotifyDegradedAsync("立即关机", "立即关机命令未被执行");
            }
        };

        cancelPlanButton.Click += (_, _) => CancelShutdownPlan();

        extendButton.Click += async (_, _) =>
        {
            var extendMinutes = await ShowExtendInputDialogAsync(dialog);
            if (extendMinutes.HasValue)
            {
                if (ExtendShutdown(extendMinutes.Value))
                {
                    CloseMainDialogProgrammatically();
                    ShowOrUpdateFloatingWindow();
                }
                else
                {
                    // 适配点 3 + 06 条目 38：重计划不可用 → 撤销本地计划并回收窗口/定时器，Toast 通知失败原因。
                    StopAllStates();
                    await NotifyDegradedAsync("高级计时关机", "延长关机未生效，已取消本次关机计划");
                }
            }
        };

        dialog.Show();
        dialog.Activate();
        await Task.CompletedTask;
    }

    private void ShowOrUpdateFloatingWindow()
    {
        if (!IsPlanActive())
        {
            CloseFloatingWindowProgrammatically();
            return;
        }

        if (_floatingWindow is { IsVisible: true })
        {
            return;
        }

        var tipButton = new Button
        {
            Content = BuildCountdownText() + "  点此返回设置",
            HorizontalAlignment = HorizontalAlignment.Stretch,
            VerticalAlignment = VerticalAlignment.Stretch,
            Background = Avalonia.Media.Brushes.Transparent,
            Foreground = Avalonia.Media.Brushes.White
        };

        tipButton.Click += async (_, _) => await ShowDialogAsync();

        var timer = new DispatcherTimer { Interval = TimeSpan.FromSeconds(1) };
        timer.Tick += (_, _) =>
        {
            if (!IsPlanActive())
            {
                CloseFloatingWindowProgrammatically();
                return;
            }

            tipButton.Content = BuildCountdownText() + "  点此返回设置";
        };

        var floatWindow = new Window
        {
            Width = 320,
            Height = 56,
            CanResize = false,
            Topmost = true,
            ShowInTaskbar = false,
            WindowDecorations = WindowDecorations.None,
            Background = Brushes.Transparent,
            TransparencyLevelHint = [WindowTransparencyLevel.Transparent],
            Content = new Border
            {
                CornerRadius = new CornerRadius(10),
                Padding = new Thickness(10, 6),
                Background = new SolidColorBrush(Color.FromArgb(210, 20, 20, 20)),
                Opacity = 0.88,
                Child = tipButton
            }
        };

        floatWindow.Opened += (_, _) => PinFloatingWindowTopRight(floatWindow);
        floatWindow.PositionChanged += (_, _) => PinFloatingWindowTopRight(floatWindow);
        floatWindow.Closing += (_, e) =>
        {
            if (!_allowFloatingWindowClose && IsPlanActive())
            {
                e.Cancel = true;
                PinFloatingWindowTopRight(floatWindow);
            }
        };
        floatWindow.Closed += (_, _) =>
        {
            timer.Stop();
            if (ReferenceEquals(_floatingWindow, floatWindow))
            {
                _floatingWindow = null;
            }
        };

        _floatingWindow = floatWindow;
        floatWindow.Show();
        timer.Start();
    }

    private static void PinFloatingWindowTopRight(Window window)
    {
        var screen = window.Screens.ScreenFromWindow(window) ?? window.Screens.Primary;
        if (screen is null)
        {
            return;
        }

        var area = screen.WorkingArea;
        var scaling = Math.Max(0.5, window.RenderScaling);
        var widthDip = window.Bounds.Width > 0 ? window.Bounds.Width : window.Width;
        var marginPx = (int)Math.Round(12 * scaling);
        var widthPx = (int)Math.Round(widthDip * scaling);

        var x = area.X + area.Width - widthPx - marginPx;
        var y = area.Y + marginPx;
        var target = new PixelPoint(Math.Max(area.X, x), Math.Max(area.Y, y));

        if (window.Position != target)
        {
            window.Position = target;
        }
    }

    private void CloseMainDialogProgrammatically()
    {
        if (_activeDialog is not { } dialog)
        {
            return;
        }

        _allowMainDialogClose = true;
        dialog.Close();
        _allowMainDialogClose = false;
        _activeDialog = null;
    }

    private void CloseFloatingWindowProgrammatically()
    {
        if (_floatingWindow is not { } window)
        {
            return;
        }

        _allowFloatingWindowClose = true;
        window.Close();
        _allowFloatingWindowClose = false;
        _floatingWindow = null;
    }

    private static async Task<int?> ShowExtendInputDialogAsync(Window owner)
    {
        var dialog = new ExtendShutdownDialog
        {
            Topmost = true,
            ShowInTaskbar = false
        };

        var previousTopmost = owner.Topmost;
        owner.Topmost = false;
        try
        {
            await dialog.ShowDialog(owner);
            return dialog.ResultMinutes;
        }
        finally
        {
            owner.Topmost = previousTopmost;
            owner.Activate();
        }
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