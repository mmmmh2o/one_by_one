# UI 改进与自定义扩展方案

> 编写日期：2026-04-01
> 项目：工具箱 (one_by_one)
> 基于：现有 24 个工具模块 + Material 3 主题系统 + 14 项自定义设置

---

## 一、UI 修改建议

### 🔴 P1 — 影响体验

#### 1. 首页缺少"身份感"的 Hero 区域

当前首页：Appbar → SearchBar → Chips → 直接进 Grid，没有呼吸空间，信息密度太高。

**建议：** 在搜索栏上方加一个简短的 App 标语 / 工具数量概览。

```
┌─────────────────────────────┐
│  工具箱                      │
│  24 个实用工具，随时调用       │  ← 轻量 slogan
├─────────────────────────────┤
│  🔍 搜索工具...              │
├─────────────────────────────┤
│  全部 | 转换 | 文本 | 编解码   │
```

- **文件：** `lib/features/home/home_page.dart`，`SliverAppBar` 和搜索栏之间插入 `SliverToBoxAdapter`
- **工作量：** 15 min
- **效果：** ⭐⭐⭐

#### 2. 网格卡片图标同质化

所有卡片图标背景统一使用 `primaryContainer`，24 个工具放在一起视觉单调。

**建议：** 按类别分配不同色调的 icon 背景。

```dart
// 在 ToolCategory 枚举上加颜色映射
Color get chipColor {
  switch (this) {
    case ToolCategory.conversion: return cs.tertiaryContainer;
    case ToolCategory.text:       return cs.secondaryContainer;
    case ToolCategory.calculation:return cs.primaryContainer;
    case ToolCategory.random:     return cs.errorContainer.withOpacity(0.5);
    case ToolCategory.media:      return cs.tertiaryContainer;
    case ToolCategory.device:     return cs.primaryContainer;
    default:                      return cs.surfaceContainerHighest;
  }
}
```

- **文件：** `lib/models/tool_entry.dart` + `lib/features/home/widgets/home_tool_grid_card.dart`
- **工作量：** 20 min
- **效果：** ⭐⭐⭐

#### 3. 水平工具栏（最近/收藏）太矮太窄

当前 `height: 88`，`width: 108`，文字经常被截断，图标也小。

**建议调整：**

- 高度 88 → 100
- 宽度 108 → 120
- 图标尺寸 24 → 28
- 增加顶部 padding 让图标不贴顶

- **文件：** `lib/features/home/widgets/home_horizontal_tool_row.dart`
- **工作量：** 10 min
- **效果：** ⭐⭐

---

### 🟡 P2 — 提升品质

#### 4. 搜索空状态太素

搜索无结果时只显示一个 `search_off` 图标 + "没有找到匹配的工具"。

**建议：** 加引导性文案 + 建议操作。

```dart
Column(
  children: [
    Icon(Icons.search_off_rounded, size: 64, color: cs.outline),
    SizedBox(height: AppSpacing.md),
    Text('没有找到"$query"'),
    SizedBox(height: AppSpacing.xs),
    TextButton(
      onPressed: () => ref.read(_searchQueryProvider.notifier).state = '',
      child: Text('清除搜索'),
    ),
  ],
)
```

- **文件：** `lib/features/home/home_page.dart` 的 `_emptyState` 方法
- **工作量：** 15 min
- **效果：** ⭐⭐

#### 5. `_TapScale` 重复实现

`home_horizontal_tool_row.dart` 中有 `_TapScale`，审计报告建议提取为通用组件。

**建议：** 移到 `lib/core/widgets/tap_scale.dart`，作为 `AppTapScale` 复用。

- **工作量：** 10 min
- **效果：** ⭐

#### 6. 分类 Chips 没有图标

当前分类 chip 只有纯文字标签，辨识度低。

**建议：** 每个分类加前置小图标。

```dart
ToolCategory.calculation: '🔢 计算',
ToolCategory.conversion:  '🔄 转换',
ToolCategory.text:        '📝 文本',
ToolCategory.random:      '🎲 随机',
ToolCategory.media:       '🎨 媒体',
ToolCategory.device:      '📱 设备',
```

- **文件：** `lib/features/home/widgets/home_category_chips.dart`
- **工作量：** 15 min
- **效果：** ⭐⭐

#### 7. 首页网格 `childAspectRatio: 1.15` 偏正方形

工具卡片是 icon + 标题 + 可选描述，纵向内容比横向多，正方形卡片底部留白浪费。

**建议：** 调为 1.3 ~ 1.4，让卡片稍微竖长，内容更从容。

- **文件：** `lib/features/home/home_page.dart` 的 `_buildGrid` 方法
- **工作量：** 5 min
- **效果：** ⭐⭐

---

### 🟢 P3 — 锦上添花

#### 8. 工具卡长按菜单加"分享"选项

当前 BottomSheet 只有"收藏"和"打开"。作为工具类 App，分享工具链接很有用。

- **工作量：** 15 min
- **效果：** ⭐

#### 9. 下拉刷新指示器美化

当前 `RefreshIndicator` 只是重播入场动画，可以考虑自定义颜色或轻量图标。

- **工作量：** 10 min
- **效果：** ⭐

#### 10. 搜索栏加"最近搜索"历史

首次点击搜索栏时，展示最近 3~5 个搜索词，点击快速填入。

- **工作量：** 20 min
- **效果：** ⭐

---

## 二、自定义扩展建议

### 当前已有设置（14 项 + 4 预设）

| 分类 | 已有选项 |
|------|---------|
| 主题 | 跟随系统 / 浅色 / 深色 |
| 强调色 | 绿 / 蓝 / 橙 |
| 动态取色 | 莫奈取色（Android 12+） |
| 预设方案 | 紧凑效率 / 大字阅读 / 极简卡片 / 高对比无障碍 |
| 卡片圆角 | 8~28 滑块 |
| 文字缩放 | 0.9~1.2x 滑块 |
| 图标缩放 | 0.85~1.3x 滑块 |
| 界面密度 | 舒适 / 紧凑 |
| 卡片风格 | 柔和渐变 / 纯色扁平 |
| 网格列数 | 自动 / 2 / 3 / 4 |
| 阴影强度 | 关闭 / 柔和 / 明显 |
| 动画 | 开关 |
| 工具描述 | 显示 / 隐藏 |
| 高对比模式 | 开关 |

### 🎨 视觉与个性化

#### 1. 自定义种子色

当前只有绿/蓝/橙三个预设色。加一个颜色选择器，让用户自由取色作为 Material You 种子色。

- 新增枚举：`UiAccent.custom`
- 新增字段：`customSeedColor (int)`
- UI：accent 选项旁加色块，点击弹出 ColorPicker
- **难度：** ⭐⭐
- **价值：** ⭐⭐⭐

#### 2. 从图片提取配色

用户选一张图，用 `palette_generator`（已有依赖）提取主色作为种子色。与已有 palette_generator 工具形成闭环。

- **难度：** ⭐⭐
- **价值：** ⭐⭐

#### 3. 首页布局风格扩展

不只是网格/列表，加一个**紧凑列表**模式（类似 iOS 设置那种单行纯文字 + 小图标），适合工具数量多时快速扫视。

- 新增枚举：`UiHomeLayout { grid, list, compactList }`
- **难度：** ⭐⭐⭐
- **价值：** ⭐⭐⭐

#### 4. 网格间距自定义

当前网格间距硬编码为 12。可做成滑块，范围 4~20。

- **难度：** ⭐
- **价值：** ⭐⭐

#### 5. 字体选择

已有 `google_fonts` 依赖但没暴露给用户。加 3~4 个中文字体选项。

- 新增枚举：`UiFont { system, notoSansSC, zCOOLKuaiLe, lxgwWenKai }`
- 「霞鹜文楷」和「站酷快乐体」在中文用户中很受欢迎
- **难度：** ⭐
- **价值：** ⭐⭐⭐

---

### ⚡ 行为与交互

#### 6. 震动反馈

新增开关：触控时是否触发 haptic feedback。轻点工具卡片给 light impact，增强触感。

- **难度：** ⭐
- **价值：** ⭐⭐

#### 7. 工具打开方式

当前所有工具都是 push 进入。可加选项：

- **页面模式**（默认 push）
- **底部弹窗模式**（modal bottom sheet 打开，适合随机数、骰子等快用工具）

需在工具注册表中标记哪些工具支持 sheet 模式。

- 新增枚举：`UiToolOpenMode { page, bottomSheet }`
- **难度：** ⭐⭐⭐
- **价值：** ⭐⭐

#### 8. 首页固定工具（Pin）

让用户 pin 3~5 个工具固定在首页最顶部，不受搜索/分类筛选影响。比"收藏"更激进——永远在视线内。

- 新增 Provider：`pinnedToolsProvider (Set<String>)`
- 首页搜索栏下方加 PinRow
- 长按菜单加"固定到首页"选项
- **难度：** ⭐⭐⭐
- **价值：** ⭐⭐⭐

#### 9. 卡片滑动手势

- 首页卡片左右滑动 → 快速收藏/取消收藏（类似邮件 App）
- 工具页左边缘右滑 → 返回（可做更宽触发区域）
- **难度：** ⭐⭐
- **价值：** ⭐⭐

---

### 🔐 隐私与数据

#### 10. 应用锁

用 `local_auth`（生物识别）或简单密码保护 App 打开。工具箱可能包含编码/解码工具的使用记录。

- 新增依赖：`local_auth`
- 新增设置：应用锁开关 + 锁类型（指纹/面容/密码）
- **难度：** ⭐⭐
- **价值：** ⭐⭐

#### 11. 使用记录管理

当前 `recentToolsProvider` 没有清除入口。在设置里加：

- 清除最近使用记录
- 关闭记录功能
- 自动清除时间（7 天 / 30 天 / 永不）
- **难度：** ⭐
- **价值：** ⭐⭐

#### 12. 设置导入/导出

把 `SettingsState` 序列化为 JSON，支持导出备份和导入恢复。方便换机或分享配置。

- **难度：** ⭐
- **价值：** ⭐

---

### 🌍 差异化功能

#### 13. URL Scheme / Deep Link

注册 `toolbox://tool/random_number` 这样的 deep link，可从桌面快捷方式或外部 App 直接打开指定工具。

- **难度：** ⭐⭐
- **价值：** ⭐⭐

#### 14. 桌面小工具配置

Android 上为高频工具（如随机数、计算器）创建 home screen widget 快捷入口。

- **难度：** ⭐⭐⭐
- **价值：** ⭐⭐

#### 15. "今日工具"随机推荐

首页新增可选区块：每天推荐一个没用过的工具，引导探索。

- 新增设置：`showDailyTool (bool)`
- 首页在 PinRow 之下、Category 之上展示
- 用日期种子随机选一个不在 recents 里的工具
- **难度：** ⭐
- **价值：** ⭐⭐⭐

---

## 三、汇总表

### UI 修改

| # | 修改项 | 工作量 | 效果 |
|---|--------|--------|------|
| 1 | 首页 Hero 标语区 | 15 min | ⭐⭐⭐ |
| 2 | 图标按类别着色 | 20 min | ⭐⭐⭐ |
| 3 | 水平工具栏尺寸加大 | 10 min | ⭐⭐ |
| 4 | 搜索空状态增强 | 15 min | ⭐⭐ |
| 5 | _TapScale 提取复用 | 10 min | ⭐ |
| 6 | 分类 Chips 加图标 | 15 min | ⭐⭐ |
| 7 | 卡片宽高比调优 | 5 min | ⭐⭐ |
| 8 | 长按菜单加分享 | 15 min | ⭐ |
| 9 | 刷新指示器美化 | 10 min | ⭐ |
| 10 | 搜索历史 | 20 min | ⭐ |

### 自定义扩展

| # | 自定义项 | 类别 | 难度 | 用户价值 |
|---|---------|------|------|---------|
| 1 | 自定义种子色 | 视觉 | ⭐⭐ | ⭐⭐⭐ |
| 2 | 图片提取配色 | 视觉 | ⭐⭐ | ⭐⭐ |
| 3 | 紧凑列表布局 | 视觉 | ⭐⭐⭐ | ⭐⭐⭐ |
| 4 | 网格间距滑块 | 视觉 | ⭐ | ⭐⭐ |
| 5 | 字体选择 | 视觉 | ⭐ | ⭐⭐⭐ |
| 6 | 震动反馈 | 交互 | ⭐ | ⭐⭐ |
| 7 | 工具打开方式 | 交互 | ⭐⭐⭐ | ⭐⭐ |
| 8 | 首页固定工具 | 交互 | ⭐⭐⭐ | ⭐⭐⭐ |
| 9 | 卡片滑动手势 | 交互 | ⭐⭐ | ⭐⭐ |
| 10 | 应用锁 | 隐私 | ⭐⭐ | ⭐⭐ |
| 11 | 使用记录管理 | 隐私 | ⭐ | ⭐⭐ |
| 12 | 设置导入导出 | 数据 | ⭐ | ⭐ |
| 13 | URL Scheme | 差异化 | ⭐⭐ | ⭐⭐ |
| 14 | 桌面小工具 | 差异化 | ⭐⭐⭐ | ⭐⭐ |
| 15 | 今日工具推荐 | 差异化 | ⭐ | ⭐⭐⭐ |
