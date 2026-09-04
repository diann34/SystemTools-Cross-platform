using Avalonia;
using Avalonia.Controls;
using Avalonia.Markup.Xaml;
using System;
using Avalonia.Input;
using Avalonia.Threading;
using ClassIsland.Core.Controls;

namespace SystemTools.CrossPlatform.Views;

/// <summary>
/// 高级计时关机对话框（p2-01 B5 附属；源锚点 E:\My Github Projects\SystemTools\Views\AdvancedShutdownDialog.axaml(.cs)
/// 随源逐行，仅命名空间/x:Class 改写为 SystemTools.CrossPlatform.Views；基类 MyWindow 为双分支 PRESENT 宿主类型，p2-05 §4）。
/// </summary>
public partial class AdvancedShutdownDialog : MyWindow
{
    public AdvancedShutdownDialog()
    {
        InitializeComponent();

        this.GetPropertyChangedObservable(Window.WindowStateProperty).Subscribe(e =>
        {
            if (this.WindowState == WindowState.Minimized)
            {
                Dispatcher.UIThread.Post(() =>
                {
                    this.WindowState = WindowState.Normal;
                    this.Activate();
                    this.InvalidateVisual();
                }, DispatcherPriority.MaxValue);
            }
        });

        //this.Closing += (s, e) => { e.Cancel = true; };
    }

    public TextBlock? CountdownTextBlock => this.FindControl<TextBlock>("CountdownTextBlockElement");
    public ProgressBar? CountdownProgressBar => this.FindControl<ProgressBar>("CountdownProgressBarElement");
    public Button? ImmediateShutdownButton => this.FindControl<Button>("ImmediateShutdownButtonElement");
    public Button? ReadButton => this.FindControl<Button>("ReadButtonElement");
    public Button? CancelPlanButton => this.FindControl<Button>("CancelPlanButtonElement");
    public Button? ExtendButton => this.FindControl<Button>("ExtendButtonElement");

    private void InitializeComponent()
    {
        AvaloniaXamlLoader.Load(this);
    }
}
