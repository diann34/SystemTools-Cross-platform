using System;
using System.Diagnostics;
using System.IO;

namespace SystemTools.CrossPlatform.Actions;

// ============================================================================
// 系统电源命令执行器（单一 net10.0 产物，运行期平台分派）
// ============================================================================
// 由多 TFM 时代的条件文件对（Actions\SystemPowerCommandWindows.cs / SystemPowerCommandStub.cs）
// 合并而来：不再按编译平台选择实现，同一 IL 在任意平台运行。
// - 非 Windows：Is*Available 恒 false、Run* 恒返回 -1（"启动失败/不可用"）；
//   行动层原有的运行时预检（!OperatingSystem.IsWindows() → Toast「…在当前平台不可用，
//   已跳过执行」）在 Windows 与非 Windows 上都生效，语义与条件文件时代完全一致。
// - Windows：命令文件存在性预检 + 有界等待执行，机制与随源实现逐条一致：
//     计时关机 shutdown.exe /s /t <秒>        立即关机 /s /t 0
//     立即重启 /g /t 0（源为 ntdll + ExitWindowsEx，按等效命令口径落地）
//     取消计划 /a                             锁定屏幕 rundll32 user32.dll,LockWorkStation
//     睡眠 rundll32 powrprof.dll,SetSuspendState 0,1,0（同步调用，1.5s 有界等待）
// - 返回约定：-1 = 启动失败；-2 = 有界等待超时（未确认）；否则为进程退出码（0 = 命令已接受）。
// ============================================================================
internal static class SystemPowerCommand
{
    private static string GetSystemToolPath(string fileName)
    {
        var systemDirectory = Environment.SystemDirectory;
        if (string.IsNullOrEmpty(systemDirectory))
        {
            systemDirectory = Environment.GetFolderPath(Environment.SpecialFolder.System);
        }
        return Path.Combine(string.IsNullOrEmpty(systemDirectory) ? "." : systemDirectory, fileName);
    }

    // ---- 能力预检（命令文件存在性，不触发任何电源动作；非 Windows 恒 false） ----

    internal static bool IsShutdownCommandAvailable()
        => OperatingSystem.IsWindows() && File.Exists(GetSystemToolPath("shutdown.exe"));

    internal static bool IsRundll32CommandAvailable()
        => OperatingSystem.IsWindows() && File.Exists(GetSystemToolPath("rundll32.exe"));

    // ---- 执行（仅 Windows 有效；非 Windows 恒返回 -1，由行动层预检提前拦截） ----

    internal static int RunTimedShutdown(int seconds)
        => Run("shutdown.exe", $"/s /t {Math.Max(0, seconds)}", 3000);

    internal static int RunImmediateShutdown()
        => Run("shutdown.exe", "/s /t 0", 3000);

    internal static int RunImmediateRestart()
        => Run("shutdown.exe", "/g /t 0", 3000);

    internal static int RunCancelScheduledShutdown()
        => Run("shutdown.exe", "/a", 3000);

    internal static int RunLockWorkstation()
        => Run("rundll32.exe", "user32.dll,LockWorkStation", 3000);

    internal static int RunSleep()
        => Run("rundll32.exe", "powrprof.dll,SetSuspendState 0,1,0", 1500);

    private static int Run(string fileName, string arguments, int waitForExitMilliseconds)
    {
        if (!OperatingSystem.IsWindows())
        {
            // 非 Windows 无等价系统命令：按"启动失败/不可用"返回（U4 降级由行动层承载）。
            return -1;
        }

        try
        {
            var psi = new ProcessStartInfo
            {
                FileName = fileName,
                Arguments = arguments,
                UseShellExecute = false,
                CreateNoWindow = true,
                WindowStyle = ProcessWindowStyle.Hidden
            };
            using var process = Process.Start(psi);
            if (process == null)
            {
                return -1;
            }

            if (process.WaitForExit(waitForExitMilliseconds))
            {
                return process.ExitCode;
            }

            return -2;
        }
        catch
        {
            return -1;
        }
    }
}
