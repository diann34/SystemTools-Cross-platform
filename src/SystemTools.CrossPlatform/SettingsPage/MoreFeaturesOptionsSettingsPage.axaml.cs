using Avalonia.Controls;
using Avalonia.Interactivity;
using ClassIsland.Core.Abstractions.Controls;
using ClassIsland.Core.Attributes;
using ClassIsland.Shared;
using SystemTools.CrossPlatform.ConfigHandlers;
using SystemTools.CrossPlatform.Services;
using SystemTools.CrossPlatform.Shared;

namespace SystemTools.CrossPlatform.SettingsPage;

/// <summary>
/// 更多功能选项页（阶段 1 A 档骨架，礼部 p1-06；源 SettingsPage\MoreFeaturesOptionsSettingsPage.axaml.cs；
/// 阶段 3 批次一接线，兵部 p3-01，落点权威 p3-05 §2.1）。
/// 骨架面：虚拟放学选项组（VirtualAfterSchoolEnabled/TriggerTime/DurationSeconds，MainConfigData A 档
/// 成员，p1-04 增补），切换语义随源：写配置 → ApplyConfig → 落盘（源 :59-68 先例，服务为 p1-04 交付）。
/// 「自动清理 ClassIsland 内存」开关组（写配置 → 服务 ApplyConfig → 落盘）。
/// 源页其余开关组（自动切换 ClassIsland 主题 / 主界面遮挡文字时 / 自动清理内存（管理员）/
/// 自动播放（USB））均已随对应功能移除，本页不再呈现。
/// </summary>
[SettingsPageInfo("SystemTools.CrossPlatform.settings.more", "更多功能选项…", "\uE28E", "\uE28E", true)]
[Group("SystemTools.CrossPlatform.settings")]
public partial class MoreFeaturesOptionsSettingsPage : SettingsPageBase
{
    public MainConfigData Config => GlobalConstants.MainConfig!.Data;

    public MoreFeaturesOptionsSettingsPage()
    {
        InitializeComponent();
        DataContext = this;
    }

    private void VirtualAfterSchoolToggle_OnChanged(object? sender, RoutedEventArgs e)
    {
        if (sender is ToggleSwitch toggleSwitch)
        {
            Config.VirtualAfterSchoolEnabled = toggleSwitch.IsChecked == true;
        }

        IAppHost.TryGetService<VirtualAfterSchoolService>()?.ApplyConfig();
        GlobalConstants.MainConfig?.Save();
    }

    /// <summary>自动清理 ClassIsland 内存（随源；ClassIslandMemoryAutoCleanupService：
    /// GC 链三平台执行 + 工作集修剪仅 Windows 生效）。</summary>
    private void AutoCleanupMemoryToggle_OnChanged(object? sender, RoutedEventArgs e)
    {
        if (sender is ToggleSwitch toggleSwitch)
        {
            Config.AutoCleanupClassIslandMemory = toggleSwitch.IsChecked == true;
        }

        var service = IAppHost.GetService<ClassIslandMemoryAutoCleanupService>();
        service.ApplyConfig();
        GlobalConstants.MainConfig?.Save();
    }

}