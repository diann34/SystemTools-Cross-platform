using System.Text.Json.Serialization;

namespace SystemTools.CrossPlatform.Settings;

/// <summary>
/// 「显示悬浮窗」行动设置。抽取自源插件 Settings\ShowFloatingWindowSettings.cs
/// （命名空间按 p1-05 §3.2 目录镜像规则调整，其余逐行保留源实现）。
/// </summary>
public class ShowFloatingWindowSettings
{
    [JsonPropertyName("notifyOnExecute")]
    public bool NotifyOnExecute { get; set; } = false;

    [JsonPropertyName("showFloatingWindow")]
    public bool ShowFloatingWindow { get; set; } = true;
}
