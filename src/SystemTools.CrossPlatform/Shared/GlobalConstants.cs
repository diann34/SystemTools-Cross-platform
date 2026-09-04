using SystemTools.CrossPlatform.ConfigHandlers;

namespace SystemTools.CrossPlatform.Shared;

/// <summary>
/// 共享静态持有者（首个需要者：p1-03 A3/A4/A6）。
/// 阶段 1 仅引入 A 档所需成员：配置根句柄、插件配置目录与插件目录
/// （初始化接线点在 Plugin.cs，由礼部 p1-06 按源 Plugin.cs:67-70 先例赋值）；
/// 其余成员由后续需要批次按需增补。
/// </summary>
public static class GlobalConstants
{
    public static string? PluginConfigFolder { get; set; }

    public static MainConfigHandler? MainConfig { get; set; }

    public static class Information
    {
        public static string PluginFolder { get; set; } = string.Empty;

        // p1-04 增补（源 Shared\GlobalConstants.cs:21；消费方 Version\VersionCheckService.cs:22）。
        public static string PluginVersion { get; set; } = "???";
    }

    // p1-04 增补（源 Shared\GlobalConstants.cs:24；写方 Version\VersionCheckService.cs:92，读方礼部 p1-06 AboutSettingsPage）。
    public static bool ShowChangelogOnOpen { get; set; } = false;
}
