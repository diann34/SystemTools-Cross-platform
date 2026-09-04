using System;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Avalonia.Controls;
using Avalonia.Interactivity;
using ClassIsland.Core.Abstractions.Controls;
using ClassIsland.Core.Attributes;
using ClassIsland.Shared;
using FluentAvalonia.UI.Controls;
using SystemTools.CrossPlatform.ConfigHandlers;
using SystemTools.CrossPlatform.Services;
using SystemTools.CrossPlatform.Shared;

namespace SystemTools.CrossPlatform.SettingsPage;

/// <summary>
/// 主设置页（阶段 1 A 档骨架，礼部 p1-06；源 SettingsPage\SystemToolsSettingsPage.axaml.cs；
/// 阶段 3 批次一接线，兵部 p3-01，落点权威 p3-05 §2.1）。
/// 骨架面：AI 服务选项组（EnableAiService 开关 + 使用协议、AiProviderName/AiApiKey/AiApiUrl/AiModel，
/// MainConfigData A 档成员）与「更多功能选项」导航。
/// p3-01 接线面：W1「启用功能选项」管理抽屉（源 :21-149/:524-558；枚举白名单=注册面 41 项，
/// C 条目结构性零呈现；保存后重启走 <see cref="SettingsPageBase.RequestRestart"/>，源
/// RestartClassIsland Win 进程替换路径不迁，p1-06 §6-8 口径）；W2「启用悬浮窗功能」开关
/// （源 :88-91/:199-206，写配置+落盘+请求重启，源 RestartPropertyChanged 事件不迁，p1-06 §9-7 等价口径）；
/// A 面补全：页头标签与「当前使用模型」AiModel 只读消费（源 :153-165/:286-300 适配，p3-05 §3.4-2）。
/// 源页 C 档面（实验性功能、扩展功能下载、语音唤醒、液态玻璃样式、悬浮窗触发器拖拽处理器）零迁入
/// （p3-05 §3.1 C1-C13；拖拽处理器组归 p3-02 面）。显示文案随源不改。
/// </summary>
[HidePageTitle]
[SettingsPageInfo("SystemTools.CrossPlatform.settings.main", "主设置", "\uE079", "\uE078")]
[Group("SystemTools.CrossPlatform.settings")]
public partial class SystemToolsSettingsPage : SettingsPageBase
{
    public MainConfigData Config => GlobalConstants.MainConfig!.Data;

    public ObservableCollection<string> AvailableAiModels { get; } = [];

    public SystemToolsSettingsPage()
    {
        if (GlobalConstants.MainConfig == null)
        {
            GlobalConstants.MainConfig = new MainConfigHandler(GlobalConstants.PluginConfigFolder
                                                               ?? Path.Combine(
                                                                   Environment.GetFolderPath(
                                                                       Environment.SpecialFolder.LocalApplicationData),
                                                                   "ClassIsland", "Plugins", "SystemTools.CrossPlatform"));
        }

        ViewModel = new SystemToolsSettingsViewModel(GlobalConstants.MainConfig,
            IAppHost.TryGetService<FloatingWindowProfileManager>());
        DataContext = this;
        InitializeComponent();

        // W1 抽屉清单初始化（源 :52 InitializeFeatureItems 随源；源 :53 RefreshFloatingTriggers
        // 为悬浮窗触发器面，归 p3-02 批，不迁；源 :54-55 RestartPropertyChanged/PropertyChanged
        // 订阅不迁——新配置根无 RestartPropertyChanged，重启经各开关处理器显式 RequestRestart）。
        ViewModel.InitializeFeatureItems();

        if (!string.IsNullOrWhiteSpace(Config.AiModel))
        {
            AvailableAiModels.Add(Config.AiModel);
        }
    }

    public SystemToolsSettingsViewModel ViewModel { get; }

    private async void AiServiceToggle_OnClick(object? sender, RoutedEventArgs e)
    {
        if (sender is not ToggleSwitch toggleSwitch)
        {
            return;
        }

        if (toggleSwitch.IsChecked != true)
        {
            Config.EnableAiService = false;
            GlobalConstants.MainConfig?.Save();
            RequestRestart();
            return;
        }

        toggleSwitch.IsEnabled = false;
        var accepted = await ShowAiServiceAgreementAsync();
        toggleSwitch.IsEnabled = true;
        if (!accepted)
        {
            toggleSwitch.IsChecked = false;
            return;
        }

        Config.EnableAiService = true;
        GlobalConstants.MainConfig?.Save();
        RequestRestart();
    }

    private async void GetAiModelsButton_OnClick(object? sender, RoutedEventArgs e)
    {
        if (sender is not Button button)
        {
            return;
        }

        var originalContent = button.Content;
        button.IsEnabled = false;
        button.Content = "正在获取...";

        try
        {
            var service = IAppHost.GetService<IOpenAiCompatibleService>();
            var models = await service.GetModelsAsync();
            if (models.Count == 0)
            {
                await ShowAiMessageAsync("未找到模型", "供应商返回了空的模型列表。");
                return;
            }

            var previousModel = Config.AiModel;
            AvailableAiModels.Clear();
            foreach (var model in models)
            {
                AvailableAiModels.Add(model);
            }

            Config.AiModel = models.Contains(previousModel, StringComparer.Ordinal)
                ? previousModel
                : models[0];
            GlobalConstants.MainConfig?.Save();

            await ShowAiMessageAsync("获取成功", $"已获取 {models.Count} 个可用模型。");
        }
        catch (Exception ex)
        {
            await ShowAiMessageAsync("获取模型失败", ex.Message);
        }
        finally
        {
            button.Content = originalContent;
            button.IsEnabled = Config.EnableAiService;
        }
    }

    private async Task<bool> ShowAiServiceAgreementAsync()
    {
        var agreementCheckBox = new CheckBox
        {
            Content = new TextBlock
            {
                Text = "我已阅读本协议，自愿承担使用AI带来的不确定风险",
                TextWrapping = Avalonia.Media.TextWrapping.Wrap,
                MaxWidth = 520
            }
        };
        var dialog = new FAContentDialog
        {
            Title = "AI 服务使用协议",
            Content = new StackPanel
            {
                Spacing = 16,
                MaxWidth = 540,
                Children =
                {
                    new TextBlock
                    {
                        Text = "此“AI 服务”是由SystemTools插件提供的外接 API Key 的AI辅助功能，与ClassIsland软件无关；\n" +
                               "AI的回复和相关服务由对应提供商提供，与本插件及开发者无关；\n" +
                               "使用课表问答或修改功能时，当前档案中的课表、时间表、科目、任课教师及扩展配置会发送给您配置的 AI 服务提供商；\n" +
                               "须知应当正确使用AI，合理规避不确定性风险，明辨AI提供的相关回复。",
                        TextWrapping = Avalonia.Media.TextWrapping.Wrap
                    },
                    agreementCheckBox
                }
            },
            CloseButtonText = "取消",
            PrimaryButtonText = "确定",
            DefaultButton = FAContentDialogButton.Close,
            IsPrimaryButtonEnabled = false
        };

        agreementCheckBox.IsCheckedChanged += (_, _) =>
            dialog.IsPrimaryButtonEnabled = agreementCheckBox.IsChecked == true;

        return await dialog.ShowAsync(TopLevel.GetTopLevel(this)) == FAContentDialogResult.Primary;
    }

    // p4-01 裁量（门下省阶段 3 验收 O-9 形态统一，对齐 p3-02 D4 口径与
    // FloatingWindowEditorSettingsPage.axaml.cs 先例）：TopLevel 获取需实例上下文，
    // 静态辅助去 static 最小适配（三处调用点均为本页实例方法，调用点零改动）。
    private async Task ShowAiMessageAsync(string title, string message)
    {
        var dialog = new FAContentDialog
        {
            Title = title,
            Content = message,
            PrimaryButtonText = "确定",
            DefaultButton = FAContentDialogButton.Primary
        };

        var topLevel = TopLevel.GetTopLevel(this)
                       ?? throw new InvalidOperationException("无法访问设置窗口");
        await dialog.ShowAsync(topLevel);
    }

    private void OnOpenMoreFeaturesClick(object? sender, RoutedEventArgs e)
    {
        IAppHost.TryGetService<ClassIsland.Core.Abstractions.Services.IUriNavigationService>()
            ?.NavigateWrapped(new Uri("classisland://app/settings/SystemTools.CrossPlatform.settings.more?ci_keepHistory=true"));
    }

    // ===== p3-01 增补开始（W1 功能管理抽屉处理器 + W2 悬浮窗功能开关处理器；源
    // SystemToolsSettingsPage.axaml.cs:524-557/:88-91 形态随源）=====

    /// <summary>打开「启用功能选项」抽屉（源 :524-529 随源；枚举白名单见共享 VM InitializeFeatureItems）。</summary>
    private void OnManageFeaturesClick(object? sender, RoutedEventArgs e)
    {
        ViewModel.UpdateFeatureSearchResults(null);
        ViewModel.FeatureDrawerContent = new object();
        ViewModel.IsFeatureDrawerOpen = true;
    }

    /// <summary>抽屉搜索框文本变化（源 :531-539 随源）。</summary>
    private void OnFeatureSearchTextBoxTextChanged(object? sender, TextChangedEventArgs e)
    {
        if (sender is not TextBox textBox)
        {
            return;
        }

        ViewModel.UpdateFeatureSearchResults(textBox.Text);
    }

    /// <summary>关闭抽屉（源 :547-550 随源）。</summary>
    private void OnCloseDrawerClick(object? sender, RoutedEventArgs e)
    {
        ViewModel.IsFeatureDrawerOpen = false;
    }

    /// <summary>
    /// 应用并重启（源 :552-557 随源：SaveFeatureSettings + 关抽屉 + 重启；重启实现走宿主
    /// SettingsPageBase.RequestRestart()，源 RestartClassIsland() Win 进程替换路径不迁，p1-06 §6-8）。
    /// </summary>
    private void OnSaveFromDrawerClick(object? sender, RoutedEventArgs e)
    {
        ViewModel.SaveFeatureSettings();
        ViewModel.IsFeatureDrawerOpen = false;
        RequestRestart();
    }

    /// <summary>
    /// W2 悬浮窗功能开关（源 :88-91 随源；配置写入由 TwoWay 绑定承载，源 :203）。适配点：源经
    /// MainConfigData.RestartPropertyChanged 事件间接触发重启提示（源 :54/:70-73 订阅面不迁，
    /// 新配置根无该事件，p2-05 §2.1 决策注记②），按 p1-06 §9-7 等价口径在此显式落盘并请求重启。
    /// </summary>
    private void OnFloatingFeatureToggleClick(object? sender, RoutedEventArgs e)
    {
        GlobalConstants.MainConfig?.Save();
        RequestRestart();
    }

    // ===== p3-01 增补结束 =====
}