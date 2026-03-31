# 🧰 工具箱 - Flutter 开发规范

> 版本：v1.0 | 日期：2026-03-30
> 目标：构建一个轻量、模块化、可扩展的多工具集合 App

---

## 一、项目概述

- **项目名**：toolbox（或自定义）
- **技术栈**：Flutter 3.x + Dart 3.x
- **状态管理**：Riverpod
- **路由**：GoRouter
- **本地存储**：Hive（轻量）+ SharedPreferences（配置）
- **最低支持**：Android 7.0 (API 24) / iOS 13.0
- **目标**：体积 < 15MB，冷启动 < 1s，120+ 工具插件

---

## 二、目录结构

```
lib/
├── app/                        # App 入口与全局配置
│   ├── app.dart                # MaterialApp/根Widget
│   ├── router.dart             # GoRouter 路由配置
│   ├── theme.dart              # 主题定义
│   └── env.dart                # 环境变量/API Key
│
├── core/                       # 核心基础设施
│   ├── constants/              # 常量（颜色、间距、字体等）
│   ├── extensions/             # Dart/Flutter 扩展方法
│   ├── utils/                  # 工具函数（格式化、校验等）
│   ├── services/               # 全局服务（网络、存储、日志）
│   └── widgets/                # 通用组件（按钮、卡片、输入框等）
│
├── features/                   # 业务模块（每个工具一个目录）
│   ├── home/                   # 首页（工具收藏/搜索/分类浏览）
│   │   ├── home_page.dart
│   │   ├── widgets/
│   │   └── providers.dart
│   │
│   ├── ruler/                  # 尺子
│   ├── qrcode/                 # 二维码
│   ├── ocr/                    # OCR 文字识别
│   ├── translator/             # 翻译
│   ├── unit_converter/         # 单位换算
│   ├── calculator/             # 计算器
│   ├── speed_test/             # 网速测试
│   ├── image_compress/         # 图片压缩
│   ├── led_banner/             # LED 弹幕
│   ├── random/                 # 随机数/骰子/硬币
│   ├── compass/                # 指南针
│   ├── flashlight/             # 手电筒
│   ├── bmi/                    # BMI 计算
│   ├── weather/                # 天气
│   └── ...                     # 每个工具独立目录
│
├── models/                     # 数据模型
│   ├── tool_entry.dart         # 工具条目模型
│   ├── category.dart           # 分类模型
│   └── user_settings.dart      # 用户设置
│
├── l10n/                       # 国际化
│   ├── app_en.arb
│   └── app_zh.arb
│
└── main.dart                   # 入口
```

---

## 三、工具模块规范（核心）

### 3.0 三层架构原则（强制）

所有工具**必须**将界面与业务逻辑分离，严格遵守三层架构：

```
┌─────────────────────────────────┐
│       UI Layer (页面/组件)         │  ← 只管"怎么画"，不含计算
├─────────────────────────────────┤
│      State Layer (Provider)      │  ← 只管"状态流转"，桥接逻辑与 UI
├─────────────────────────────────┤
│     Logic Layer (纯 Dart 类)      │  ← 只管"怎么算"，零 Flutter 依赖
└─────────────────────────────────┘
```

**规则：**
- Logic 层是纯 Dart，不 import `package:flutter/*`，可独立单元测试
- UI 层只读 Provider 状态 + 调用 Provider 方法，不直接写业务逻辑
- Provider 负责组合 Logic 层调用 + 管理状态，是唯一的"胶水层"
- 将来做 Web 版 / CLI 版可直接复用 Logic 层

### 3.1 单个工具的标准目录结构

每个工具必须遵循以下结构：

```
features/<tool_name>/
├── logic/                        # 纯 Dart 业务逻辑（零 Flutter 依赖）
│   └── <logic_file>.dart         # 核心算法/转换/处理（可含枚举/模型）
├── providers.dart                # Riverpod 状态管理（桥接层）
├── <tool_name>_page.dart         # 主页面
└── widgets/                      # （可选）复杂子组件拆分
```

**实际示例（calculator）：**
```
features/calculator/
├── logic/
│   └── calculator_engine.dart    # CalcOperator 枚举 + CalculatorEngine 类
├── providers.dart                # CalculatorState + CalculatorNotifier
└── calculator_page.dart          # ConsumerStatefulWidget 页面
```

### 3.2 三层职责速查

| 层级 | 职责 | 能 import 什么 | 不能做什么 |
|------|------|----------------|-----------|
| Logic | 算法、转换、校验、格式化 | `dart:core`, `dart:math` 等标准库 | 不能 import flutter/widget/state |
| Provider | 状态管理、组合 Logic 调用 | Logic 层 + Riverpod | 不能写 UI 逻辑 |
| UI | 渲染、交互、动画 | Provider + Flutter 全家桶 | 不能写计算逻辑 |

### 3.2 工具注册机制

所有工具通过统一注册表管理：

```dart
// models/tool_entry.dart

enum ToolCategory {
  daily,      // 日常
  query,      // 查询
  calculator, // 计算
  text,       // 文字
  image,      // 图片
  device,     // 设备
  file,       // 文件
  thirdParty, // 第三方
  other,      // 其他
}

class ToolEntry {
  final String id;              // 唯一标识，如 'ruler'
  final String name;            // 显示名称
  final String description;     // 简介
  final IconData icon;          // 图标
  final ToolCategory category;  // 所属分类
  final WidgetBuilder builder;  // 页面构建器
  final bool isPremium;         // 是否会员专属
  final bool isOffline;         // 是否支持离线
  final int sortOrder;          // 排序权重

  const ToolEntry({...});
}
```

```dart
// core/registry/tool_registry.dart

final List<ToolEntry> allTools = [
  ToolEntry(
    id: 'ruler',
    name: '尺子',
    description: '屏幕尺子，支持厘米/英寸',
    icon: Icons.straighten,
    category: ToolCategory.daily,
    builder: (_) => const RulerPage(),
    isOffline: true,
    sortOrder: 1,
  ),
  ToolEntry(
    id: 'qrcode',
    name: '二维码',
    description: '生成与扫描二维码',
    icon: Icons.qr_code,
    category: ToolCategory.daily,
    builder: (_) => const QrcodePage(),
    isOffline: true,
    sortOrder: 2,
  ),
  // ... 注册所有工具
];
```

### 3.3 工具页面模板

```dart
// features/ruler/ruler_page.dart

class RulerPage extends ConsumerWidget {
  const RulerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('尺子'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showUsage(context),
          ),
        ],
      ),
      body: const _RulerBody(),
    );
  }
}
```

---

## 四、命名与编码规范

### 4.1 命名约定

| 类型 | 规范 | 示例 |
|------|------|------|
| 文件名 | snake_case.dart | `unit_converter_page.dart` |
| 类名 | PascalCase | `UnitConverterPage` |
| 变量/函数 | camelCase | `convertResult` |
| 常量 | camelCase / k prefix | `kDefaultPadding` |
| Provider | camelCase + Provider 后缀 | `final weatherProvider` |
| 路由名 | kebab-case | `/unit-converter` |
| 工具 ID | snake_case | `'image_compress'` |

### 4.2 Dart 代码规范

- 严格遵守 [Effective Dart](https://dart.dev/guides/language/effective-dart)
- 每行最大长度：**120 字符**
- 使用 `const` 构造函数（能用就用）
- 避免 `dynamic`，优先强类型
- 使用 `final` / `late final` 替代可变变量
- Widget 拆分：单文件不超过 **300 行**，超过则拆分

### 4.3 注释规范

```dart
/// 尺子页面 - 提供屏幕尺子功能
///
/// 支持厘米和英寸两种单位，
/// 通过 [MediaQuery.size] 计算屏幕 DPI 实现。
class RulerPage extends ConsumerWidget { ... }

// 私有方法用 // 注释
Widget _buildRulerLine() { ... }
```

---

## 五、状态管理规范（Riverpod）

### 5.1 Provider 定义规则

```dart
// ✅ 推荐：函数式 Provider
final calculationResultProvider = Provider<double>((ref) {
  return 0.0;
});

// ✅ 推荐：StateNotifier 用于复杂状态
class RulerState extends StateNotifier<RulerData> {
  RulerState() : super(RulerData.initial());

  void setUnit(Unit unit) => state = state.copyWith(unit: unit);
}

final rulerProvider = StateNotifierProvider<RulerState, RulerData>(
  (ref) => RulerState(),
);

// ❌ 避免：全局可变状态
double globalResult = 0.0;
```

### 5.2 Provider 文件位置

- 工具专属 Provider → `features/<tool>/providers.dart`
- 全局 Provider（主题、用户设置）→ `core/providers/`

---

## 六、路由规范（GoRouter）

```dart
// app/router.dart

final goRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const HomePage(),
    ),
    // 工具路由统一用 /tool/:id 模式
    GoRoute(
      path: '/tool/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final tool = allTools.firstWhere((t) => t.id == id);
        return tool.builder(context);
      },
    ),
    // 或者为高频工具写死路由
    GoRoute(
      path: '/ruler',
      builder: (_, __) => const RulerPage(),
    ),
  ],
);
```

---

## 七、UI/设计规范

### 7.1 设计原则

- **严格遵循 Material Design 3 (MD3)**：使用 `useMaterial3: true`、`ColorScheme.fromSeed()` 派生色。
- **语义化颜色**：UI 必须使用 `Theme.of(context).colorScheme.*`，禁止硬编码 `Color(0x...)`。
- **间距系统**：统一使用 `AppSpacing` 常量（4/8/16/24/32/48），禁止裸数字。
- **圆角统一**：通过 `settings.cardRadius` 动态控制，不要在组件内写死。
- **文字缩放**：所有工具结果文案必须用 `scaledTextStyle()` 包裹，读取 `settings.textScaleFactor`。
- **深色模式**：所有页面必须同时适配亮色和暗色主题。
- **图标容器**：工具图标统一用 `primaryContainer` 色调容器包裹，保持视觉一致。

### 7.2 间距常量

```dart
// core/constants/spacing.dart

abstract class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}
```

### 7.3 通用组件

当前已实现的通用组件，位于 `lib/core/widgets/` 和 `lib/features/common/`：

| 组件 | 路径 | 用途 |
|------|------|------|
| `ToolScaffold` | `features/common/tool_scaffold.dart` | 统一工具页外壳（AppBar + padding） |
| `AppCard` | `core/widgets/app_card.dart` | 统一卡片容器 |
| `AppInput` | `core/widgets/app_input.dart` | 统一输入框 |
| `AppButton` | `core/widgets/app_button.dart` | 统一按钮 |
| `scaledTextStyle` | `core/utils/ui_text_scale.dart` | 响应文字缩放 |

**新增工具页面必须使用 `ToolScaffold` + `AppCard` + `AppButton`，禁止自行搭 Scaffold。**

### 7.4 工具卡片组件

首页工具卡片（`_ToolGridCard` / `_ToolListTile`）已内置在 `home_page.dart`，新工具无需自定义首页卡片。

---

## 7.5 启动性能优化（强制）

### 启动路径

```
main()
  ├── WidgetsFlutterBinding.ensureInitialized()
  ├── ProviderContainer() → 预加载 settingsProvider hydration
  ├── await waitForHydration()  ← 阻塞，仅等 SharedPreferences（~5ms）
  └── UncontrolledProviderScope → App → MaterialApp.router
```

### 规则

1. **Settings 必须等 hydration 完成再渲染**：使用 `UncontrolledProviderScope` + `waitForHydration()`，避免首帧闪屏（默认主题 → 用户主题）。
2. **Provider 懒加载**：非首页依赖的 Provider 使用 `autoDispose`，避免启动时初始化所有状态。
3. **DynamicColorBuilder 非阻塞**：莫奈取色是平台异步回调，不影响首帧。
4. **路由懒加载**：GoRouter 默认按需构建页面，不要预加载所有工具页面。
5. **禁止在 main() 中做 IO**：除 settings hydration 外，其他 IO（网络、数据库）必须异步。

### 首屏渲染时序

```
T+0ms    main() 开始
T+10ms   WidgetsFlutterBinding 初始化
T+20ms   SharedPreferences 读取（~5ms on modern devices）
T+25ms   Settings hydration → 用用户配置渲染首帧
T+30ms   MaterialApp.router 构建
T+40ms   首帧渲染（HomePage + SliverAppBar + SearchBar）
T+50ms   DynamicColorBuilder 回调（仅莫奈用户，无感知切换）
```

**目标：冷启动到首帧 < 100ms（不含 Flutter engine init）。**

---

## 八、主题规范

主题由 `AppTheme.light(settings, {monetScheme})` / `AppTheme.dark(settings, {monetScheme})` 动态生成。

核心特性：
- `useMaterial3: true`，全面使用 `ColorScheme` 派生色。
- 支持莫奈取色（`dynamic_color` 包）：Android 12+ 壁纸动态取色。
- 支持三套种子色（green/ocean/amber）手动切换。
- `scrolledUnderElevation` 自动提升（滚动时 AppBar 阴影）。
- `SearchBarThemeData` / `ChipThemeData` / `BottomSheetThemeData` 统一配色。

**禁止在工具页面硬编码颜色，必须使用 `Theme.of(context).colorScheme.*`。**

---

## 九、依赖管理

### 9.1 核心依赖

```yaml
# pubspec.yaml

dependencies:
  flutter:
    sdk: flutter

  # 状态管理
  flutter_riverpod: ^2.5.x
  riverpod_annotation: ^2.3.x

  # 路由
  go_router: ^14.x

  # 本地存储
  hive: ^2.2.x
  hive_flutter: ^1.1.x
  shared_preferences: ^2.x

  # 网络
  dio: ^5.x
  retrofit: ^4.x

  # UI
  google_fonts: ^6.x
  flutter_screenutil: ^5.x    # 屏幕适配
  shimmer: ^3.x               # 骨架屏

  # 工具相关（按需引入）
  mobile_scanner: ^5.x        # 二维码扫描
  qr_flutter: ^4.x            # 二维码生成
  sensors_plus: ^5.x          # 传感器（指南针等）
  image_picker: ^1.x          # 图片选择
  image: ^4.x                 # 图片处理
  path_provider: ^2.x         # 路径
  share_plus: ^9.x            # 分享
  url_launcher: ^6.x          # 打开链接
  connectivity_plus: ^6.x     # 网络状态
  package_info_plus: ^8.x     # 包信息
  flutter_tts: ^3.x           # TTS 语音

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.x
  build_runner: ^2.x
  riverpod_generator: ^2.x
  hive_generator: ^2.x
  mockito: ^5.x
```

### 9.2 依赖引入原则

- **按需引入**：不要为了"以后可能用到"就加依赖
- **审核质量**：优先选 pub.dev 评分高、维护活跃的包
- **控制体积**：关注包的大小，大包考虑懒加载或在线方案
- **版本锁定**：核心依赖用 `^` 允许小版本更新，但不要裸写不带范围

---

## 十、Git 规范

### 10.1 分支策略

```
main          ← 生产分支，只接受 MR
├── dev       ← 开发主分支
│   ├── feature/ruler
│   ├── feature/qrcode
│   ├── feature/ocr
│   └── fix/crash-on-android-12
└── release/* ← 发布分支
```

### 10.2 Commit 规范（Conventional Commits）

```
feat(ruler): 新增尺子工具支持英寸单位
fix(qrcode): 修复扫描后闪退的问题
refactor(core): 重构工具注册机制
docs: 更新 README
chore: 升级 Flutter SDK 到 3.24
```

类型前缀：
- `feat` - 新功能
- `fix` - 修复
- `refactor` - 重构
- `docs` - 文档
- `style` - 格式（不影响逻辑）
- `perf` - 性能优化
- `test` - 测试
- `chore` - 构建/工具

### 10.3 .gitignore

```gitignore
# Flutter
.dart_tool/
.packages
build/
.flutter-plugins
.flutter-plugins-dependencies

# IDE
.idea/
.vscode/
*.iml

# 平台
android/.gradle/
ios/Pods/
ios/.symlinks/

# 环境
.env
*.env.local
```

---

## 十一、测试规范

### 11.1 测试覆盖要求

| 层级 | 覆盖率要求 | 测试类型 |
|------|-----------|---------|
| 核心工具函数 | 90%+ | 单元测试 |
| Provider/状态 | 80%+ | 单元测试 |
| UI 组件 | 60%+ | Widget 测试 |
| 关键流程 | 100% | 集成测试 |

### 11.2 测试目录

```
test/
├── core/
│   ├── utils/
│   └── services/
├── features/
│   ├── ruler/
│   │   ├── ruler_page_test.dart
│   │   └── ruler_provider_test.dart
│   └── calculator/
├── models/
└── widgets/
```

### 11.3 测试示例

```dart
// test/features/unit_converter/unit_converter_test.dart

void main() {
  group('UnitConverter', () {
    test('厘米转英寸', () {
      expect(convertLength(2.54, LengthUnit.cm, LengthUnit.inch), 1.0);
    });

    test('摄氏度转华氏度', () {
      expect(convertTemperature(0, TempUnit.celsius, TempUnit.fahrenheit), 32.0);
    });
  });
}
```

---

## 十二、构建与发布

### 12.1 构建命令

```bash
# Android Release
flutter build apk --release --split-per-abi
flutter build appbundle --release

# iOS Release
flutter build ios --release
```

### 12.2 体积优化

- 启用 R8/ProGuard（Android）
- 使用 `--split-per-abi` 按架构分包
- 图标用 SVG/IconFont 替代 PNG
- 大型 ML 模型考虑在线加载或按需下载
- 去除无用依赖

### 12.3 CI/CD（推荐 GitHub Actions）

```yaml
# .github/workflows/build.yml
name: Build & Test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.x'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test

  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter build appbundle --release
```

---

## 十三、新增工具 Checklist

每次新增一个工具，必须完成以下清单：

- [ ] 在 `features/` 下创建工具目录
- [ ] 实现页面、Provider、必要模型
- [ ] 在 `tool_registry.dart` 中注册
- [ ] 添加路由（如果需要深链接）
- [ ] 编写单元测试
- [ ] 编写 Widget 测试（关键交互）
- [ ] 添加中英文国际化文本
- [ ] 检查暗色模式适配
- [ ] 检查不同屏幕尺寸适配
- [ ] 更新 README 功能列表

---

## 十四、代码审查 Checklist

PR 合并前审查项：

- [ ] 无 `print()` / `debugPrint()` 残留
- [ ] 无硬编码字符串（国际化）
- [ ] 无硬编码颜色/尺寸（使用常量/主题）
- [ ] Widget 拆分合理（单文件 < 300 行）
- [ ] Provider 生命周期正确（无内存泄漏）
- [ ] 异步操作有 loading/error 状态
- [ ] 通过 `flutter analyze` 无警告
- [ ] 测试通过

---

## 附录：MVP 工具清单（第一批）

按优先级排序，建议先做这些：

| 序号 | 工具 | 复杂度 | 依赖 |
|------|------|--------|------|
| 1 | 尺子 | ⭐ | 无 |
| 2 | 二维码生成/扫描 | ⭐⭐ | qr_flutter, mobile_scanner |
| 3 | 单位换算 | ⭐ | 无 |
| 4 | 计算器 | ⭐ | 无 |
| 5 | LED 弹幕 | ⭐ | 无 |
| 6 | 随机数/骰子/硬币 | ⭐ | 无 |
| 7 | 指南针 | ⭐⭐ | sensors_plus |
| 8 | 手电筒 | ⭐ | torch_light |
| 9 | 图片压缩 | ⭐⭐ | image |
| 10 | 翻译 | ⭐⭐ | 在线 API |
| 11 | OCR 文字识别 | ⭐⭐⭐ | ML Kit / 在线 API |
| 12 | 网速测试 | ⭐⭐ | connectivity_plus |
| 13 | BMI 计算 | ⭐ | 无 |
| 14 | 天气查询 | ⭐⭐ | 在线 API |
| 15 | 表情包制作 | ⭐⭐ | image |

---

> 💡 **记住**：先做好 10 个工具的体验，胜过做 100 个半成品。

---

## 十七、当前落地进展（2026-04-01）

### 已完成
- **24 个工具首版**，全部遵循三层架构：`logic/`（纯Dart）→ `providers.dart`（Riverpod）→ `*_page.dart`（UI）。
- **MD3 主界面**：SliverAppBar.large 可折叠标题栏 + SearchBar 实时过滤 + FilterChip 分类筛选 + 分组视图 + 最近使用/收藏横向区 + 网格/列表切换 + 卡片按压缩放动效 + 长按上下文菜单。
- **莫奈取色**：`dynamic_color` 包接入，Android 12+ 壁纸取色，设置面板开关。
- **收藏 & 最近使用**：SharedPreferences 持久化，首页展示，长按收藏。
- **启动优化**：Settings hydration 完成后再渲染首帧，避免主题闪屏。
- **UI 自定义系统**：主题/密度/强调色/圆角/动画/文字缩放/图标缩放/网格列数/阴影/高对比/预设方案，全部持久化。
- **通用模板**：`ToolScaffold` + `AppCard` + `AppButton` + `AppInput` + `scaledTextStyle`。
- **CI/CD**：GitHub Actions 构建工作流 + 平台目录自动检测。
- **仓库治理**：README / docs / .github / .gitignore / analysis_options.yaml。

### 待完成
- 测试覆盖（单元测试 / Widget 测试）
- Phase 2 工具开发
- 首页文件拆分（home_page.dart 999 行 → 拆分 SettingsSheet 和卡片组件）

---

## 十八、UI 规范增强（自定义选项）

为满足不同用户偏好，UI 层新增"可配置外观"规范：

- **主题模式**：支持 `system/light/dark` 切换。
- **界面密度**：支持 `comfortable/compact`，影响网格间距、输入与卡片留白。
- **强调色**：支持 `green/ocean/amber` 三套品牌色种子。
- **卡片圆角**：支持 8-24 之间滑动调节，统一作用于卡片与部分容器。
- **动画开关**：可开关过渡动画（低性能设备可关闭）。
- **文字缩放**：支持 `0.9-1.2` 调整，首页与工具卡片文本需实时响应。
- **描述显隐**：支持首页工具描述开关，提升信息密度可调性。
- **卡片风格**：支持 `soft(渐变)` / `flat(纯色)` 两套卡片视觉。
- **恢复默认**：提供一键恢复外观默认值的入口。
- **图标缩放**：支持 `0.85-1.30` 调整，首页工具图标实时响应。
- **网格列数**：支持 `auto/2/3/4`，适配不同屏幕与用户偏好。
- **预设方案**：支持一键应用 `紧凑效率`、`大字阅读`、`极简卡片`、`高对比无障碍`。
- **预设追踪**：需记录 `currentPreset`（含 `custom`），当用户手动调整任意项后自动切回 `custom`。
- **配置持久化**：所有 UI 自定义项必须通过本地存储持久化（重启后保持不变）。
- **阴影强度**：支持 `off/soft/strong`。
- **高对比模式**：支持开关，开启后提升边框和前景对比。

实现要求：

- 所有配置统一存放在 `core/providers/settings_provider.dart`。
- 主题必须由 `AppTheme.light(settings)` / `AppTheme.dark(settings)` 动态生成。
- 首页提供可视化"UI 自定义"入口用于实时预览配置效果。
- 新增页面不得绕开全局设置单独写死视觉参数。
- `ToolPageTemplate` 必须受 `enableAnimations` 控制，不允许页面自行硬编码动画时长。

### 18.1 调用文档（UI 自定义）

#### 1) 读取配置

```dart
final settings = ref.watch(settingsProvider);
```

#### 2) 修改配置

```dart
final notifier = ref.read(settingsProvider.notifier);
notifier.setThemeMode(ThemeMode.dark);
notifier.setDensity(UiDensity.compact);
notifier.setAccent(UiAccent.ocean);
notifier.setCardRadius(18);
notifier.setAnimations(false);
notifier.setTextScaleFactor(1.1);
notifier.setShowToolDescription(true);
notifier.setCardStyle(UiCardStyle.soft);
notifier.setIconScaleFactor(1.15);
notifier.setPreferredColumns(3); // 0=auto
```

#### 2.1 应用预设

```dart
final notifier = ref.read(settingsProvider.notifier);
notifier.applyPreset(UiPreset.compactEfficiency);
notifier.applyPreset(UiPreset.largeTextReading);
notifier.applyPreset(UiPreset.minimalCards);
notifier.applyPreset(UiPreset.accessibilityHighContrast);
```

#### 2.2 读取当前预设

```dart
final settings = ref.watch(settingsProvider);
final current = settings.currentPreset;
```

#### 2.3 持久化规范

- 持久化载体：`SharedPreferences`。
- 初始化流程：`SettingsNotifier` 构造后异步 `hydrate` 本地配置。
- 更新流程：每次状态更新后异步 `persist`，避免遗漏。
- key 命名：统一前缀 `ui.*`，例如 `ui.theme_mode`、`ui.text_scale`。
- 新增 key：`ui.current_preset`、`ui.shadow_level`、`ui.high_contrast`。
- 兼容策略：读取时缺省值回退到 `_defaultSettings`，并对枚举索引做边界保护。

预设建议：

- `compactEfficiency`：信息密度高，减少描述与动画，偏效率。
- `largeTextReading`：增大文字与图标，偏可读性。
- `minimalCards`：扁平卡片、较小圆角，偏简洁。
- `accessibilityHighContrast`：高对比+大字+低动画，偏可访问性。

#### 3) 一键恢复默认

```dart
ref.read(settingsProvider.notifier).resetAppearance();
```

#### 4) 主题接入要求

`app/app.dart` 必须使用：

```dart
theme: AppTheme.light(settings),
darkTheme: AppTheme.dark(settings),
themeMode: settings.themeMode,
```

#### 5) 组件接入示例

- 网格组件：读取 `density/cardRadius/cardStyle/preferredColumns/iconScaleFactor`。
- 通用页面模板：读取 `enableAnimations` 决定动画时长是否为 0。
- 文本信息组件：读取 `textScaleFactor/showToolDescription` 控制信息密度。
- 工具正文页面：关键结果文案需读取 `textScaleFactor` 统一缩放。

### 18.2 接口清单（settingsProvider）

#### 字段

- `themeMode`、`density`、`accent`、`cardRadius`、`enableAnimations`
- `textScaleFactor`、`showToolDescription`、`cardStyle`
- `iconScaleFactor`、`preferredColumns`、`currentPreset`
- `shadowLevel`、`highContrast`

#### 方法

- `setThemeMode` / `setDensity` / `setAccent`
- `setCardRadius` / `setAnimations`
- `setTextScaleFactor` / `setShowToolDescription` / `setCardStyle`
- `setIconScaleFactor` / `setPreferredColumns`
- `setShadowLevel` / `setHighContrast`
- `applyPreset` / `resetAppearance`

---

## 十五、功能规划与追踪（结合 FEATURE_TRACKER）

- **唯一来源**：所有功能状态以 `FEATURE_TRACKER.md` 为准，完成后立刻更新状态、负责人和备注。
- **状态流转**：`🔴 未开始` → `🟡 进行中` → `🟢 已完成` → `🔵 已发布`，如需搁置用 `⚪ 暂缓` 并写明原因。
- **分阶段开发**：优先按 `Phase 1-5` 批次推进，提交/PR 描述需标注所属 Phase（例：`Phase 1 - 单位换算`）。
- **分支规范补充**：针对单个工具使用 `feature/<tool_id>`（如 `feature/ruler`），跨工具 Phase 任务可用 `phase/<n>-batch`。
- **Issue/PR 关联**：每个工具开发对应一条任务记录；PR 描述包含：工具名、状态更新、是否离线/会员、依赖包变更、测试范围。
- **Checklist 对齐**：新增工具时同时勾选本规范的"新增工具 Checklist"和 `FEATURE_TRACKER.md` 的状态，缺一不可。
- **度量与验收**：
  - MVP（Phase 1-2）必须满足：冷启动 < 1s、包体 < 15MB、核心流程全量测试。
  - 在线类工具必须写明所用 API、鉴权方式、速率限制，并在备注标记 Mock/真实环境。
  - 传感器/设备类工具需说明权限弹窗与降级策略。
  - 图片/文件类工具需说明本地处理还是上传处理，涉及隐私的数据不落盘或需加密存储。

---

## 十六、代码复用与共享准则

- **纯逻辑优先复用**：通用算法/转换/校验放 `core/utils/` 或工具下 `logic/`，禁止在 UI/Provider 重复实现。
- **组件共享**：常用交互/呈现组件沉淀到 `core/widgets/`（按钮、卡片、输入框、占位/错误、网格项等），新增前先查已有组件能否参数化复用。
- **常量集中**：颜色/间距/字体/动画时长/正则/错误文案集中在 `core/constants/`，禁止硬编码到工具内。
- **模型与类型**：跨工具可复用的数据结构放 `models/`，避免在各工具内定义重复枚举/DTO。
- **服务与适配器**：网络、存储、权限、传感器封装在 `core/services/`，工具层通过 Provider 注入，避免直接依赖底层包。
- **新依赖前置检查**：引入第三方包前先确认现有依赖能否覆盖；如需新增，评估体积/维护度并在 PR 描述中说明复用与影响范围。
- **模板复用**：新增页面优先使用现有 Scaffold/列表/Grid/设置页模板，减少样式漂移；表单/输入逻辑用统一表单校验与输入组件。
- **命名与封装**：可配置的差异通过参数/泛型/策略模式封装，避免复制文件后微调魔改。
