using System.Text.Json.Serialization;

namespace SystemTools.CrossPlatform.Settings;

/// <summary>
/// 计时关机行动设置（p2-01 B4；源锚点 E:\My Github Projects\SystemTools\Settings\ShutdownSettings.cs 全 13 行逐成员随源）。
/// ShowPrompt：源 :40-44 以 WinForms 按键模拟自动确认系统确认框；按 06 条目 37 该手段删除，
/// 成员保留随源配置兼容，跨平台不承诺各 OS 相同的系统确认 UI（06 条目 37 拟纳入边界）。
/// </summary>
public class ShutdownSettings
{
    [JsonPropertyName("notifyOnExecute")]
    public bool NotifyOnExecute { get; set; } = false;

    [JsonPropertyName("seconds")] public int Seconds { get; set; } = 60;

    [JsonPropertyName("showPrompt")] public bool ShowPrompt { get; set; } = true;
}
