using System;
using Avalonia.Controls;
using Avalonia.Interactivity;
using ClassIsland.Core.Abstractions.Controls;
using SystemTools.CrossPlatform.Rules;

namespace SystemTools.CrossPlatform.Controls;

/// <summary>
/// 「是否在某时间段」规则设置控件（代码后置）。抽取自源插件 Controls\InTimePeriodRuleSettingsControl.cs
/// （命名空间按 p1-05 §3.2 目录镜像规则调整并补充规则设置类型引用，其余逐行保留源实现；
/// axaml 成对文件 InTimePeriodRuleSettingsControl.axaml 随本批引入，x:Class 与各 XML 命名空间声明已同步镜像）。
/// </summary>
public partial class InTimePeriodRuleSettingsControl : RuleSettingsControlBase<InTimePeriodRuleSettings>
{
    public InTimePeriodRuleSettingsControl()
    {
        InitializeComponent();
    }

    private void StartTimePicker_OnLoaded(object? sender, RoutedEventArgs e)
    {
        if (sender is TimePicker picker && TimeSpan.TryParse(Settings.StartTime, out var start))
        {
            picker.SelectedTime = start;
        }
    }

    private void EndTimePicker_OnLoaded(object? sender, RoutedEventArgs e)
    {
        if (sender is TimePicker picker && TimeSpan.TryParse(Settings.EndTime, out var end))
        {
            picker.SelectedTime = end;
        }
    }

    private void StartTimePicker_OnSelectedTimeChanged(object? sender, TimePickerSelectedValueChangedEventArgs e)
    {
        if (sender is TimePicker { SelectedTime: { } selectedTime })
        {
            Settings.StartTime = selectedTime.ToString(@"hh\:mm\:ss");
        }
    }

    private void EndTimePicker_OnSelectedTimeChanged(object? sender, TimePickerSelectedValueChangedEventArgs e)
    {
        if (sender is TimePicker { SelectedTime: { } selectedTime })
        {
            Settings.EndTime = selectedTime.ToString(@"hh\:mm\:ss");
        }
    }
}
