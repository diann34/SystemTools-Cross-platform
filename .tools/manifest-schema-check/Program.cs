// p0-05 manifest schema 校验工具（案卷 stcp-cross-platform-001 / 礼部 interfaces-documentation / assignment p0-05）
//
// 复刻宿主解析行为（逐项对照）：
// - DeserializerBuilder 配置 = ClassIsland\Services\PluginService.cs:68-72（IgnoreUnmatchedProperties +
//   OSPlatformTypeConverter_Yaml + CamelCaseNamingConvention），PluginService.cs:119-123 为同款。
// - OSPlatformTypeConverter_Yaml 逐行复刻自 E:\ClassIsland-git-misha\ClassIsland\Converters\OSPlatformTypeConverter.cs:11-36
//   （U3 快照 2.1.1.1 / a8af81ba37ec1e83588148a400a00a9d8548560d；YAML 读取分支，WriteYaml 不需要故省略）。
// - 模型 PluginManifest 来自宿主 bin 的 ClassIsland.Core.dll（ClassIsland.Core\Models\Plugin\PluginManifest.cs:10-73）。
//
// 用法：manifest-schema-check <待校验 manifest.yml> [源插件 manifest.yml（对照 dump，只读）]
// 退出码：0 = 全部断言通过；2 = 存在断言失败；1 = 读取/解析异常。

using System.Reflection;
using System.Text;
using ClassIsland.Core.Enums;
using ClassIsland.Core.Models.Plugin;
using YamlDotNet.Core;
using YamlDotNet.Serialization;
using YamlDotNet.Serialization.NamingConventions;

// —— 复刻 OSPlatformTypeConverter_Yaml（源：ClassIsland\Converters\OSPlatformTypeConverter.cs:11-36）——
public class OSPlatformTypeConverter_Yaml : IYamlTypeConverter
{
    public bool Accepts(Type type)
    {
        return type == typeof(OSPlatform);
    }

    public object ReadYaml(YamlDotNet.Core.IParser parser, Type type, ObjectDeserializer deserializer)
    {
        var scalar = parser.Consume<YamlDotNet.Core.Events.Scalar>();

        string value = scalar.Value;

        if (value.Equals("Windows", StringComparison.OrdinalIgnoreCase))
            return OSPlatform.Windows;
        if (value.Equals("Linux", StringComparison.OrdinalIgnoreCase))
            return OSPlatform.Linux;
        if (value.Equals("OSX", StringComparison.OrdinalIgnoreCase) || value.Equals("macOS", StringComparison.OrdinalIgnoreCase))
            return OSPlatform.macOS;
        if (value.Equals("Android", StringComparison.OrdinalIgnoreCase))
            return OSPlatform.Android;
        if (value.Equals("iOS", StringComparison.OrdinalIgnoreCase))
            return OSPlatform.iOS;

        return OSPlatform.Unknown;
    }

    public void WriteYaml(YamlDotNet.Core.IEmitter emitter, object? value, Type type, ObjectSerializer serializer)
    {
        // 校验工具只需读取分支；写分支见源文件 :38-56。
        throw new NotSupportedException("p0-05 check tool only deserializes.");
    }
}

internal static class Program
{
    private const string OriginalPluginId = "SystemTools";
    private const string ExpectedNewId = "SystemTools-Cross-platform";
    private const string ExpectedEntranceAssembly = "SystemTools.CrossPlatform.dll";
    private const string ExpectedNewVersion = "1.0.0.0";
    private const string ExpectedApiVersion = "2.0.0.0";
    private const string ReservedFeaturePrefix = "SystemTools.CrossPlatform.";
    private static readonly System.Version HostApiVersionFloor = new(2, 0, 0, 0); // PluginService.cs:168-171 加载下限
    private static readonly string[] ExpectedPlatforms = ["Windows", "Linux", "macOS"];

    private static int _failures;

    public static int Main(string[] args)
    {
        Console.OutputEncoding = Encoding.UTF8;
        if (args.Length < 1)
        {
            Console.Error.WriteLine("usage: manifest-schema-check <manifest.yml> [source-manifest.yml]");
            return 1;
        }

        var checkPath = args[0];
        var sourcePath = args.Length > 1 ? args[1] : null;

        Console.WriteLine("== p0-05 manifest schema check ==");
        Console.WriteLine($"tool-assembly-version: {typeof(Program).Assembly.GetName().Version}");
        Console.WriteLine($"classisland-core-assembly: {typeof(PluginManifest).Assembly.GetName().Name} {typeof(PluginManifest).Assembly.GetName().Version}");
        Console.WriteLine($"yamldotnet-assembly: {typeof(IYamlTypeConverter).Assembly.GetName().Name} {typeof(IYamlTypeConverter).Assembly.GetName().Version}");
        Console.WriteLine($"host-api-version-floor: {HostApiVersionFloor} (ClassIsland\\Services\\PluginService.cs:168-171)");
        Console.WriteLine($"deserializer-config-replicated-from: PluginService.cs:68-72 (IgnoreUnmatchedProperties + OSPlatformTypeConverter_Yaml + CamelCaseNamingConvention)");
        Console.WriteLine($"converter-replicated-from: ClassIsland\\Converters\\OSPlatformTypeConverter.cs:11-36");
        Console.WriteLine($"check-target: {checkPath}");
        if (sourcePath != null)
        {
            Console.WriteLine($"source-compare-target: {sourcePath}");
        }

        var manifest = ParseOrThrow(checkPath);
        DumpManifest("NEW-PLUGIN", manifest);

        if (sourcePath != null)
        {
            var source = ParseOrThrow(sourcePath);
            DumpManifest("SOURCE-PLUGIN", source);
            Assert("SRC-ID", source.Id == OriginalPluginId,
                $"source manifest id = '{source.Id}' (expected '{OriginalPluginId}', unchanged baseline)");
        }

        // A1 id 独立：等于既定值且与原插件 id 零重合
        Assert("A1-ID", manifest.Id == ExpectedNewId && manifest.Id != OriginalPluginId,
            $"id = '{manifest.Id}' (expected '{ExpectedNewId}', must not be '{OriginalPluginId}')");

        // A2 入口程序集与新工程 AssemblyName（SystemTools.CrossPlatform）一致
        Assert("A2-ENTRANCE", manifest.EntranceAssembly == ExpectedEntranceAssembly,
            $"entranceAssembly = '{manifest.EntranceAssembly}' (expected '{ExpectedEntranceAssembly}')");

        // A3 新插件独立版本线
        Assert("A3-VERSION", manifest.Version == ExpectedNewVersion,
            $"version = '{manifest.Version}' (expected '{ExpectedNewVersion}'; 独立于原插件 3.0.0.0)");

        // A4 apiVersion = U3 基线宿主加载下限
        var apiOk = System.Version.TryParse(manifest.ApiVersion, out var apiVersion) && apiVersion >= HostApiVersionFloor;
        Assert("A4-APIVERSION", apiOk && manifest.ApiVersion == ExpectedApiVersion,
            $"apiVersion = '{manifest.ApiVersion}' (expected '{ExpectedApiVersion}', floor {HostApiVersionFloor})");

        // A5 三平台列表完整（同时验证 YAML 键名经 CamelCase 命名约定真正绑定：
        // 若键未绑定，该属性保持模型默认全部五平台，计数断言即失败）
        var actualPlatforms = manifest.SupportedOSPlatforms.Select(p => p.ToString()).ToHashSet();
        var expectedSet = ExpectedPlatforms.ToHashSet();
        Assert("A5-PLATFORMS", manifest.SupportedOSPlatforms.Count == 3 && actualPlatforms.SetEquals(expectedSet),
            $"supportedOSPlatforms = [{string.Join(", ", manifest.SupportedOSPlatforms)}] (expected [{string.Join(", ", ExpectedPlatforms)}])");

        // A6 显示名独立且非空
        Assert("A6-NAME", !string.IsNullOrWhiteSpace(manifest.Name) && manifest.Name != "SystemTools - Hoshimi Miyabi",
            $"name = '{manifest.Name}' (non-empty, distinct from source display name)");

        // A7 icon/readme 显式置空（新工程尚无对应资产文件，避免默认值 icon.png/README.md 悬空引用）
        Assert("A7-ICON-README", manifest.Icon == "" && manifest.Readme == "",
            $"icon = '{manifest.Icon}', readme = '{manifest.Readme}' (explicit empty: no asset files in scaffold)");

        // A8 作者（信息性字段，沿用源作者，无命名空间影响）
        Assert("A8-AUTHOR", manifest.Author == "Programmer-MrWang",
            $"author = '{manifest.Author}'");

        // A9 无依赖声明
        Assert("A9-DEPENDENCIES", manifest.Dependencies.Count == 0,
            $"dependencies count = {manifest.Dependencies.Count} (expected 0)");

        // A10 功能 ID 前缀约定（阶段 0 仅固化约定）。不相交论证：
        //   原插件功能 ID 空间 = 裸名（如 classwidgets）或 "SystemTools.<Name>"（如 SystemTools.Shutdown）；
        //   保留前缀 "SystemTools.CrossPlatform." 与之发生任何碰撞都要求原插件侧出现 "CrossPlatform" 字符串，
        //   而原插件全源码 grep 'CrossPlatform' 零命中（证据文件记录）→ 碰撞不可能。
        // 工具可机器核对的常量事实：保留前缀挂在原插件 id 家族名下且含独立段 CrossPlatform。
        Assert("A10-PREFIX", ReservedFeaturePrefix.StartsWith(OriginalPluginId + ".") && ReservedFeaturePrefix.Contains("CrossPlatform"),
            $"reserved feature prefix = '{ReservedFeaturePrefix}' (family 'SystemTools.' + independent segment 'CrossPlatform'; 原插件全源码 'CrossPlatform' 零出现 → 与原插件功能 ID 空间不相交，grep 证据见 p0-05 证据文件)");

        Console.WriteLine();
        if (_failures > 0)
        {
            Console.WriteLine($"SCHEMA-PARSE-CHECK: FAILED ({_failures} assertion(s) failed)");
            return 2;
        }

        Console.WriteLine("SCHEMA-PARSE-CHECK: PASSED (schema parse ok; id/entrance/version/apiVersion/platforms all bound and independent)");
        return 0;
    }

    private static PluginManifest ParseOrThrow(string path)
    {
        if (!File.Exists(path))
        {
            throw new FileNotFoundException($"manifest not found: {path}");
        }

        var deserializer = new DeserializerBuilder()
            .IgnoreUnmatchedProperties()
            .WithTypeConverter(new OSPlatformTypeConverter_Yaml())
            .WithNamingConvention(CamelCaseNamingConvention.Instance)
            .Build();

        using var reader = File.OpenText(path);
        return deserializer.Deserialize<PluginManifest>(reader)
               ?? throw new InvalidDataException($"deserialized manifest is null: {path}");
    }

    private static void DumpManifest(string label, PluginManifest m)
    {
        Console.WriteLine();
        Console.WriteLine($"-- dump [{label}] --");
        foreach (var p in typeof(PluginManifest).GetProperties(BindingFlags.Public | BindingFlags.Instance)
                     .OrderBy(p => p.MetadataToken))
        {
            var value = p.GetValue(m);
            var rendered = value switch
            {
                List<OSPlatform> platforms => "[" + string.Join(", ", platforms) + "]",
                List<ClassIsland.Core.Models.Plugin.PluginDependency> deps => $"count={deps.Count}",
                null => "<null>",
                _ => value.ToString() ?? "<empty>",
            };
            Console.WriteLine($"{p.Name} = {rendered}");
        }
    }

    private static void Assert(string id, bool condition, string detail)
    {
        Console.WriteLine($"[{(condition ? "PASS" : "FAIL")}] {id}: {detail}");
        if (!condition)
        {
            _failures++;
        }
    }
}
