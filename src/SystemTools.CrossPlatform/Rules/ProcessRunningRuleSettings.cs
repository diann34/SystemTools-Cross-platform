using System.Text.Json.Serialization;

namespace SystemTools.CrossPlatform.Rules;

public class ProcessRunningRuleSettings
{
    [JsonPropertyName("processName")] public string ProcessName { get; set; } = string.Empty;
}
