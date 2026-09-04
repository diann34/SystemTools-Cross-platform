using System.Text.Json.Serialization;

namespace SystemTools.CrossPlatform.Rules;

public class UsingTimeLayoutRuleSettings
{
    [JsonPropertyName("timeLayoutId")]
    public string TimeLayoutId { get; set; } = string.Empty;
}
