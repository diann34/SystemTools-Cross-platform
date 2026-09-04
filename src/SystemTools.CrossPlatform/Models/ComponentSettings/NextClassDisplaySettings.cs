using CommunityToolkit.Mvvm.ComponentModel;

namespace SystemTools.CrossPlatform.Models.ComponentSettings;

public partial class NextClassDisplaySettings : ObservableObject
{
    [ObservableProperty]
    private string _prefixText = "下节课是 ";

    [ObservableProperty]
    private bool _showTimeRange = true;

    [ObservableProperty]
    private bool _showTeacherName = true;
}
