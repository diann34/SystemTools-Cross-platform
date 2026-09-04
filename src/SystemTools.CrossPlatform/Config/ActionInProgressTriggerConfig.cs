using System;
using System.Text.Json.Serialization;
using CommunityToolkit.Mvvm.ComponentModel;

namespace SystemTools.CrossPlatform.Config;

/// <summary>
/// 「行动进行时」触发器配置。抽取自源插件 Config\ActionInProgressTriggerConfig.cs
/// （仅命名空间按 p1-05 §3.2 目录镜像规则调整，其余逐行保留源实现）。
/// </summary>
public class ActionInProgressTriggerConfig : ObservableRecipient
{
    private string _triggerId = string.Empty;

    public string TriggerId
    {
        get => _triggerId;
        set
        {
            if (_triggerId == value) return;
            _triggerId = value;
            OnPropertyChanged();
        }
    }
}
