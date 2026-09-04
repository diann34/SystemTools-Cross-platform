using System.Text.Json.Serialization;

namespace SystemTools.CrossPlatform.Rules;

public class UsingClassPlanRuleSettings
{
    [JsonPropertyName("classPlanId")]
    public string ClassPlanId { get; set; } = string.Empty;
}
