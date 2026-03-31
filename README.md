# 工具箱

一个基于 Flutter + Riverpod + GoRouter 的多工具集合应用。

## 当前状态

- 已完成项目基础骨架
- 已接入首页、主题、UI 自定义能力
- 已完成 22 个工具首版：`ruler`、`random_number`、`dice`、`unit_converter`、`coin`、`base_converter`、`date_calculator`、`calculator`、`bmi`、`json_formatter`、`morse`、`rmb_uppercase`、`random_string`、`base64_codec`、`url_codec`、`text_stats`、`text_dedup_sort`、`decision_maker`、`unicode_codec`、`text_compare`、`fullscreen_clock`、`eat_what`
- 已接入 GitHub Actions 构建工作流
- 已补齐仓库治理基础文件（`analysis_options.yaml`、`scripts/`、`.github/ISSUE_TEMPLATE/`）

## 目录结构

```text
.
├── .github/
│   ├── ISSUE_TEMPLATE/
│       └── bug_report.md      # Bug 模板
│   └── workflows/
│       └── build.yml          # GitHub Actions 构建脚本
├── scripts/
│   ├── bootstrap.ps1          # 一键初始化依赖与检查
│   └── verify.ps1             # 一键执行 analyze + test
├── assets/                    # 静态资源
├── docs/                      # 项目文档
├── lib/
│   ├── app/                   # App 入口、路由、主题
│   ├── core/                  # 常量、组件、Provider、服务、工具函数
│   ├── features/              # 业务功能模块
│   ├── l10n/                  # 国际化文案
│   ├── models/                # 跨模块模型
│   └── main.dart
├── test/                      # 测试目录
├── DEVELOPMENT_SPEC.md        # 开发规范
├── FEATURE_TRACKER.md         # 功能追踪
├── analysis_options.yaml      # Dart/Flutter Lint 配置
└── pubspec.yaml
```

## GitHub 同步前注意

- `opencode.json` 当前包含敏感凭证，已加入 `.gitignore`，不要上传到 GitHub。
- 若后续需要公开仓库，建议把本地开发配置放到 `.env` 或本地私有文件中。
- Android 签名文件 `*.jks`、`key.properties` 也已加入忽略列表。

## GitHub Actions

工作流文件位置：`.github/workflows/build.yml`

当前工作流包含：

- Artifact 清理
- `flutter analyze` + `flutter test`
- Android APK 构建
- Web 构建

当前工作流已加入平台目录自动检测：

- 若缺少 `android/` 或 `web/`，对应构建任务会自动跳过并输出引导信息
- `Analyze & Test` 仍会执行，保证代码质量反馈

## 本地开发

在安装 Flutter 后执行：

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

## 编译/校验脚本

- Windows PowerShell：`./scripts/bootstrap.ps1`
- Windows PowerShell：`./scripts/verify.ps1`
- Android 首次编译前补齐目录：`./scripts/bootstrap.ps1 -GeneratePlatforms`
- Android 编译校验：`./scripts/verify.ps1 -BuildAndroid`

说明：

- `bootstrap.ps1` 会执行 `flutter pub get`，并尝试执行 `flutter analyze`、`flutter test`
- `bootstrap.ps1 -GeneratePlatforms` 会执行 `flutter create . --platforms=android,web` 自动补齐平台目录
- `verify.ps1` 用于提交前快速校验（`analyze + test`）
- `verify.ps1 -BuildAndroid` 会在校验通过后执行 `flutter build apk --debug`

## 文档

- 开发规范：`DEVELOPMENT_SPEC.md`
- 功能跟踪：`FEATURE_TRACKER.md`
- 构建说明：`docs/github-actions.md`
- GitHub 同步检查：`docs/repo-sync-checklist.md`
- Flutter 工程补齐清单：`docs/flutter-project-bootstrap.md`

## 发布前建议

当前仓库适合先同步到 GitHub 做代码托管与文档协作。

如果要真正跑通 Android / Web 构建，请先补齐标准 Flutter 平台目录，再启用完整 CI/CD。
