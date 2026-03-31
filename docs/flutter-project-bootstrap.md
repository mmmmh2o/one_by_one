# 完整 Flutter 工程落地清单

当前仓库已经有业务层代码和基础结构，但还不等同于完整 Flutter 工程。

## 当前已有

- `lib/` 业务代码
- `pubspec.yaml`
- `l10n` 文案
- GitHub Actions 工作流
- 项目规范与功能追踪文档

## 当前缺少

标准 Flutter 工程通常还需要以下目录和文件：

- `android/`
- `ios/`
- `web/`
- `windows/`
- `linux/`
- `macos/`
- `analysis_options.yaml`
- `test/` 内的真实测试文件

## 推荐补齐方式

在本地安装 Flutter 后，在仓库根目录执行：

```bash
flutter create .
```

如果你只想先支持 Android + Web，可用：

```bash
flutter create . --platforms=android,web
```

仓库内也提供了 PowerShell 脚本（Windows）：

```powershell
./scripts/bootstrap.ps1 -GeneratePlatforms
```

如果担心覆盖现有业务代码，可以先备份，再执行。

## 补齐后需要检查

### 1. 依赖解析

```bash
flutter pub get
```

### 2. 静态检查

```bash
flutter analyze
```

### 3. 测试

```bash
flutter test
```

### 4. 本地运行

```bash
flutter run
```

### 5. 构建验证

```bash
flutter build apk --debug
flutter build web
```

PowerShell 一键校验并编译 Android：

```powershell
./scripts/verify.ps1 -BuildAndroid
```

## 与 GitHub Actions 的关系

只有补齐 Flutter 平台目录后，以下工作流步骤才有意义：

- Android APK 构建
- Android AAB 构建
- Web 构建

否则 Actions 虽然能被触发，但大概率会因为缺少平台目录而失败。

## 推荐补齐后的目录示例

```text
.
├── .github/
├── android/
├── ios/
├── web/
├── windows/
├── linux/
├── macos/
├── assets/
├── docs/
├── lib/
├── test/
├── DEVELOPMENT_SPEC.md
├── FEATURE_TRACKER.md
├── README.md
└── pubspec.yaml
```

## 建议提交顺序

1. 先提交当前业务代码与文档
2. 再补齐平台目录
3. 修复 `flutter analyze` / `flutter test` 问题
4. 最后启用正式发布流程
