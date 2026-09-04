using System;
using System.Runtime.InteropServices;

namespace SystemTools.CrossPlatform.Views;

/// <summary>
/// 系统动效偏好查询（单一 net10.0 产物，运行期平台分派）。
/// Windows：查询 SPI_GETCLIENTAREAANIMATION（动画关闭 → 应减少动效）；
/// 非 Windows：恒返回 false（无等价系统设置查询语义，与多 TFM 时代 no-op 分支一致）。
/// </summary>
internal static class SystemMotionPreferences
{
    private const uint SpiGetClientAreaAnimation = 0x1042;

    public static bool ShouldReduceMotion()
    {
        if (!OperatingSystem.IsWindows())
        {
            return false;
        }

        try
        {
            return SystemParametersInfo(
                       SpiGetClientAreaAnimation,
                       0,
                       out var enabled,
                       0) &&
                   enabled == 0;
        }
        catch
        {
            return false;
        }
    }

    [DllImport("user32.dll", SetLastError = false)]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool SystemParametersInfo(
        uint uiAction,
        uint uiParam,
        out int pvParam,
        uint fWinIni);
}
