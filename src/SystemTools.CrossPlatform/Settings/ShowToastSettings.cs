using System.Text.Json.Serialization;

namespace SystemTools.CrossPlatform.Settings;

public class ShowToastSettings
{
    [JsonPropertyName("title")] public string Title { get; set; } = string.Empty;

    [JsonPropertyName("content")] public string Content { get; set; } = string.Empty;
}
