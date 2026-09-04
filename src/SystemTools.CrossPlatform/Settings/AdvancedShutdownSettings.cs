using System.Text.Json.Serialization;

namespace SystemTools.CrossPlatform.Settings;

/// <summary>
/// 高级计时关机行动设置（p2-01 B5；源锚点 E:\My Github Projects\SystemTools\Settings\AdvancedShutdownSettings.cs 全 8 行逐成员随源）。
/// </summary>
public class AdvancedShutdownSettings
{
    [JsonPropertyName("minutes")] public int Minutes { get; set; } = 2;
}
