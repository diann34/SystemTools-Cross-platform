using Avalonia.Controls;
using Avalonia.Interactivity;
using Avalonia.Media.Imaging;
using ClassIsland.Core.Abstractions.Controls;
using ClassIsland.Core.Attributes;
using FluentAvalonia.UI.Controls;
using System;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using ClassIsland.Core.Abstractions.Services;
using ClassIsland.Shared;
using SystemTools.CrossPlatform.Services;
using SystemTools.CrossPlatform.Shared;

namespace SystemTools.CrossPlatform.SettingsPage;

[HidePageTitle]
[SettingsPageInfo("SystemTools.CrossPlatform.settings.about", "关于", "\uE9E4", "\uE9E4")]
[Group("SystemTools.CrossPlatform.settings")]
public partial class AboutSettingsPage : SettingsPageBase
{
    private readonly AboutTitleImageCacheService? _titleImageCacheService;

    public AboutSettingsViewModel ViewModel { get; }

    public AboutSettingsPage()
    {
        ViewModel = new AboutSettingsViewModel();
        DataContext = ViewModel;
        InitializeComponent();
        _titleImageCacheService = IAppHost.TryGetService<AboutTitleImageCacheService>();
        Loaded += OnLoaded;
        Unloaded += OnUnloaded;
        LoadPluginIcon();

        CheckAutoSwitchTab();
    }

    private void OnLoaded(object? sender, RoutedEventArgs e)
    {
        if (_titleImageCacheService == null)
        {
            LoadTitleImage(Path.Combine(GlobalConstants.Information.PluginFolder, "title.png"));
            return;
        }

        _titleImageCacheService.ImagePathChanged -= OnTitleImagePathChanged;
        _titleImageCacheService.ImagePathChanged += OnTitleImagePathChanged;
        LoadTitleImage(_titleImageCacheService.CurrentImagePath);
    }

    private void OnUnloaded(object? sender, RoutedEventArgs e)
    {
        if (_titleImageCacheService != null)
        {
            _titleImageCacheService.ImagePathChanged -= OnTitleImagePathChanged;
        }
    }

    private void OnTitleImagePathChanged(object? sender, string imagePath)
    {
        Avalonia.Threading.Dispatcher.UIThread.Post(() => LoadTitleImage(imagePath));
    }

    private void LoadTitleImage(string imagePath)
    {
        try
        {
            if (!File.Exists(imagePath))
            {
                return;
            }

            var bitmap = new Bitmap(imagePath);
            var previousBitmap = TitleImage.Source as Bitmap;
            TitleImage.Source = bitmap;
            previousBitmap?.Dispose();
        }
        catch (Exception ex)
        {
            Debug.WriteLine($"加载关于页顶部图像失败: {ex.Message}");
        }
    }
    
    private void UriNavigationCommands_OnClick(object sender, RoutedEventArgs e)
    {
        var url = e.Source switch
        {
            FASettingsExpanderItem s => s.CommandParameter?.ToString(),
            Button s => s.CommandParameter?.ToString(),
            _ => "classisland://app/test/"
        };
        if (!string.IsNullOrWhiteSpace(url))
        {
            IAppHost.TryGetService<IUriNavigationService>()?.NavigateWrapped(new Uri(url));
        }
    }

    private void CheckAutoSwitchTab()
    {
        if (GlobalConstants.ShowChangelogOnOpen)
        {
            ViewModel.SelectedTabIndex = 2;
            GlobalConstants.ShowChangelogOnOpen = false;
        }
    }

    private void LoadPluginIcon()
    {
        try
        {
            var iconPath = Path.Combine(
                GlobalConstants.Information.PluginFolder,
                "icon.png");

            if (File.Exists(iconPath))
            {
                var bitmap = new Bitmap(iconPath);
                PluginIcon.Source = bitmap;
            }
        }
        catch (Exception ex)
        {
            Debug.WriteLine($"加载图标失败: {ex.Message}");
        }
    }
}
public class AboutSettingsViewModel : INotifyPropertyChanged
{
    private string _currentMarkdownContent = string.Empty;
    private string _pluginVersion = "???";
    private int _selectedTabIndex = 0;

    public string CurrentMarkdownContent
    {
        get => _currentMarkdownContent;
        set
        {
            if (_currentMarkdownContent != value)
            {
                _currentMarkdownContent = value;
                OnPropertyChanged(nameof(CurrentMarkdownContent));
            }
        }
    }

    public string PluginVersion
    {
        get => _pluginVersion;
        set
        {
            if (_pluginVersion != value)
            {
                _pluginVersion = value;
                OnPropertyChanged(nameof(PluginVersion));
            }
        }
    }

    public int SelectedTabIndex
    {
        get => _selectedTabIndex;
        set
        {
            if (_selectedTabIndex != value)
            {
                _selectedTabIndex = value;
                OnPropertyChanged(nameof(SelectedTabIndex));
                OnPropertyChanged(nameof(IsHelpTab));
                OnPropertyChanged(nameof(IsNotHelpTab));
                LoadMarkdownContent();
            }
        }
    }

    public bool IsHelpTab => SelectedTabIndex == 0;
    public bool IsNotHelpTab => SelectedTabIndex != 0;

    private readonly string[] _markdownFiles =
    {
        "README.md",      // 帮助
        "README-1.md",        // 插件介绍-1
        "README-2.md"       // 更新日志
    };

    private readonly string[] _defaultContents =
    {
        "# 帮助",
        "# 插件介绍\n\n欢迎使用 SystemTools 插件！\n\n**未找到插件目录下的「README-1.md」文件。**",
        "# 更新日志\n\n**未找到插件目录下的「README-2.md」文件。**"
    };

    public AboutSettingsViewModel()
    {
        PluginVersion = GlobalConstants.Information.PluginVersion;
        LoadMarkdownContent();
    }

    private void LoadMarkdownContent()
    {
        try
        {
            if (SelectedTabIndex != 0)
            {
                var filePath = Path.Combine(
                    GlobalConstants.Information.PluginFolder,
                    _markdownFiles[SelectedTabIndex]);

                CurrentMarkdownContent = File.Exists(filePath)
                    ? File.ReadAllText(filePath)
                    : _defaultContents[SelectedTabIndex];
            }
            else
            {
                CurrentMarkdownContent = string.Empty;
            }

            Debug.WriteLine($"[SystemTools] 加载标签 {SelectedTabIndex}: {_markdownFiles[SelectedTabIndex]}");
        }
        catch (Exception ex)
        {
            CurrentMarkdownContent = $"# 错误\n\n加载文件时出错：{ex.Message}";
            Debug.WriteLine($"[SystemTools] 加载失败: {ex.Message}");
        }
    }

    public event PropertyChangedEventHandler? PropertyChanged;

    protected void OnPropertyChanged(string propertyName)
    {
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
    }
}