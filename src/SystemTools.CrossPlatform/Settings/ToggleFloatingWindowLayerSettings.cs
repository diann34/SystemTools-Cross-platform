using System.Text.Json.Serialization;

namespace SystemTools.CrossPlatform.Settings;

/// <summary>
/// 「切换悬浮窗层级」行动设置。抽取自源插件 Settings\ToggleFloatingWindowLayerSettings.cs
/// （命名空间按 p1-05 §3.2 目录镜像规则调整，其余逐行保留源实现）。
/// </summary>
public class ToggleFloatingWindowLayerSettings
{
    [JsonPropertyName("notifyOnExecute")]
    public bool NotifyOnExecute { get; set; } = false;

    // -1 表示切换，0 表示置底，1 表示置顶。
    [JsonPropertyName("targetLayer")]
    public int TargetLayer { get; set; } = -1;
}
