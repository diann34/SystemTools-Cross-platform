using System;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Threading;

namespace SystemTools.CrossPlatform.Services;

/// <summary>
/// 系统关机/会话结束监控（单一 net10.0 产物，运行期平台分派）。
/// Windows：创建隐藏的顶层消息窗口接收系统会话广播（WM_QUERYENDSESSION / WM_ENDSESSION），
/// 以纯 P/Invoke（user32）实现——由多 TFM 时代依赖 WinForms NativeWindow 的
/// 条件分支改写而来，行为与原实现一致（会话结束标记仅由窗口过程与 MarkIfOsShutdown 写入；
/// 同装隔离、插件生命周期接线不变）。
/// 非 Windows：宿主系统事件抽象无会话结束/关机事件（G2 事实），不创建任何窗口，
/// IsSessionEnding 恒为 false（no-op 护栏，与多 TFM 时代的非 Windows 分支语义一致）。
/// </summary>
public sealed class SystemShutdownMonitor : IDisposable
{
    internal const string WindowCaption = "SystemTools.CrossPlatform.SystemShutdownMonitor";

    private const int WmQueryEndSession = 0x0011;
    private const int WmEndSession = 0x0016;
    private const string WindowClassName = "SystemTools.CrossPlatform.SystemShutdownMonitorWindow";
    private const uint WsPopup = 0x80000000;

    // 会话结束标记为静态态（单实例使用；WndProc 为静态回调，无需按窗口回取实例）。
    private static int _isSessionEnding;
    private static bool _classRegistered;
    private static readonly WndProcDelegate WndProcHandler = WndProc;

    private int _isStarted;
    private IntPtr _windowHandle = IntPtr.Zero;

    public bool IsSessionEnding => Volatile.Read(ref _isSessionEnding) != 0;

    /// <summary>
    /// Windows：注册窗口类并创建隐藏窗口以接收系统会话广播；
    /// 非 Windows：no-op。重复调用与创建失败均安全返回（不抛异常，不影响插件启动）。
    /// </summary>
    public void Start()
    {
        if (!OperatingSystem.IsWindows())
        {
            return;
        }

        if (Interlocked.Exchange(ref _isStarted, 1) != 0)
        {
            return;
        }

        try
        {
            EnsureWindowClassRegistered();
            var moduleHandle = GetModuleHandleW(null);
            _windowHandle = CreateWindowExW(
                0,
                WindowClassName,
                WindowCaption,
                WsPopup,
                0, 0, 0, 0,
                IntPtr.Zero,
                IntPtr.Zero,
                moduleHandle,
                IntPtr.Zero);
            if (_windowHandle == IntPtr.Zero)
            {
                // 窗口创建失败（例如极端环境限制）：恢复未启动状态，保持会话未结束语义。
                Volatile.Write(ref _isStarted, 0);
            }
        }
        catch
        {
            Volatile.Write(ref _isStarted, 0);
            _windowHandle = IntPtr.Zero;
        }
    }

    internal void MarkSessionEnding()
    {
        Volatile.Write(ref _isSessionEnding, 1);
    }

    /// <summary>
    /// 宿主 DesktopLifetime.ShutdownRequested 处理器入口（Plugin.cs 接线）：事件参数中
    /// IsOSShutdown 为 true 时标记为系统关机路径（该属性在某些 Avalonia 版本为 internal，
    /// 故经反射读取；窗口消息面仍为兜底）。
    /// </summary>
    internal void MarkIfOsShutdown(object eventArgs)
    {
        try
        {
            var property = eventArgs.GetType().GetProperty(
                "IsOSShutdown",
                BindingFlags.Instance | BindingFlags.Public | BindingFlags.NonPublic);
            if (property?.PropertyType == typeof(bool) && property.GetValue(eventArgs) is true)
            {
                MarkSessionEnding();
            }
        }
        catch
        {
            // The property is internal in some Avalonia versions; the native window remains the fallback.
        }
    }

    public void Dispose()
    {
        if (Interlocked.Exchange(ref _isStarted, 0) == 0)
        {
            return;
        }

        if (_windowHandle != IntPtr.Zero)
        {
            DestroyWindow(_windowHandle);
            _windowHandle = IntPtr.Zero;
        }
    }

    private static IntPtr WndProc(IntPtr hWnd, uint msg, IntPtr wParam, IntPtr lParam)
    {
        switch (msg)
        {
            case WmQueryEndSession:
                Volatile.Write(ref _isSessionEnding, 1);
                break;
            case WmEndSession:
                Volatile.Write(ref _isSessionEnding, wParam != IntPtr.Zero ? 1 : 0);
                break;
        }

        return DefWindowProcW(hWnd, msg, wParam, lParam);
    }

    private static void EnsureWindowClassRegistered()
    {
        if (_classRegistered)
        {
            return;
        }

        var wndClass = new WndClassEx
        {
            cbSize = (uint)Marshal.SizeOf<WndClassEx>(),
            style = 0,
            lpfnWndProc = Marshal.GetFunctionPointerForDelegate(WndProcHandler),
            cbClsExtra = 0,
            cbWndExtra = 0,
            hInstance = GetModuleHandleW(null),
            hIcon = IntPtr.Zero,
            hCursor = IntPtr.Zero,
            hbrBackground = IntPtr.Zero,
            lpszMenuName = null,
            lpszClassName = WindowClassName,
            hIconSm = IntPtr.Zero
        };

        if (RegisterClassExW(ref wndClass) != 0)
        {
            _classRegistered = true;
            return;
        }

        // 类已注册（重复注册返回 0 且 GetLastError 为 ERROR_CLASS_ALREADY_EXISTS=1410）时视为成功。
        _classRegistered = Marshal.GetLastWin32Error() == 1410;
    }

    private delegate IntPtr WndProcDelegate(IntPtr hWnd, uint msg, IntPtr wParam, IntPtr lParam);

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Unicode)]
    private struct WndClassEx
    {
        public uint cbSize;
        public uint style;
        public IntPtr lpfnWndProc;
        public int cbClsExtra;
        public int cbWndExtra;
        public IntPtr hInstance;
        public IntPtr hIcon;
        public IntPtr hCursor;
        public IntPtr hbrBackground;
        [MarshalAs(UnmanagedType.LPWStr)] public string? lpszMenuName;
        [MarshalAs(UnmanagedType.LPWStr)] public string? lpszClassName;
        public IntPtr hIconSm;
    }

    [DllImport("user32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    private static extern ushort RegisterClassExW(ref WndClassEx wndClass);

    [DllImport("user32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    private static extern IntPtr CreateWindowExW(
        uint dwExStyle,
        [MarshalAs(UnmanagedType.LPWStr)] string lpClassName,
        [MarshalAs(UnmanagedType.LPWStr)] string lpWindowName,
        uint dwStyle,
        int x,
        int y,
        int nWidth,
        int nHeight,
        IntPtr hWndParent,
        IntPtr hMenu,
        IntPtr hInstance,
        IntPtr lpParam);

    [DllImport("user32.dll", SetLastError = false)]
    private static extern IntPtr DefWindowProcW(IntPtr hWnd, uint msg, IntPtr wParam, IntPtr lParam);

    [DllImport("user32.dll", SetLastError = true)]
    [return: MarshalAs(UnmanagedType.Bool)]
    private static extern bool DestroyWindow(IntPtr hWnd);

    [DllImport("kernel32.dll", CharSet = CharSet.Unicode, SetLastError = false)]
    private static extern IntPtr GetModuleHandleW([MarshalAs(UnmanagedType.LPWStr)] string? lpModuleName);
}