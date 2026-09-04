using System.Text.Json.Serialization;

namespace SystemTools.CrossPlatform.Settings;

/// <summary>
/// 通用“当执行时发出提醒”行动设置（共享类型：本批 A11/A13/A14/A15 首引，后续批次复用）
/// </summary>
public class ShortcutKeyNotificationSettings
{

    [JsonPropertyName("notifyOnExecute")]
    public bool NotifyOnExecute { get; set; } = false;
}
