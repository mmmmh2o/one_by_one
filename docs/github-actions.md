# GitHub Actions 说明

## 工作流位置

GitHub Actions 需要放在：

```text
.github/workflows/build.yml
```

根目录下的 `build.yml` 不会被 GitHub 自动识别为工作流。

## 当前工作流用途

- 清理旧 artifact
- 清理旧 workflow runs（定时）
- 代码分析与测试
- Android APK 打包
- Web 构建

并默认在 push 到 `main/master/develop` 时自动触发编译。

此外增加了平台目录检测：

- `check-platforms`：检测 `android/`、`web/` 是否存在
- `bootstrap-warning`：缺失平台目录时输出引导信息（不会阻塞 analyze）

## 使用前提

该工作流默认项目最终会变成完整 Flutter 工程，至少包含：

- `android/`
- `ios/`
- `web/`
- `test/`

当前仓库还处于手动脚手架阶段。为了支持“仅云端编译”，工作流会在缺失平台目录时自动执行平台补齐：

- Android 任务：缺少 `android/` 时自动执行 `flutter create . --platforms=android`
- Web 任务：缺少 `web/` 时自动执行 `flutter create . --platforms=web`

这样即使本地不补齐目录，也可以在 GitHub Actions 完成构建验证。

## 速度优化策略

- `concurrency` 开启，重复 push 时自动取消旧任务
- Flutter 缓存开启（`subosito/flutter-action` 自带）
- Android 额外缓存 Gradle 依赖与 wrapper
- 文档变更（`*.md`、`docs/**`）默认不触发构建
- 构建产物保留 2 天，减少仓库存储占用

## 自动清理策略

- 每天 UTC 03:00 自动触发清理任务（`schedule`）
- Push 时也会执行清理任务
- Artifact 超过 2 天自动删除
- Completed workflow run 超过 7 天自动删除

## 后续增强项

平台目录补齐后可再加回：

- Android AAB 打包
- 发布签名（Secrets 注入）
- Release 上传

## 建议调整

- 正式发布前，不要在工作流中硬编码 keystore 生成逻辑
- 将签名文件改为 GitHub Secrets + Base64 解码方式注入
- 当 `flutter create .` 可用后，重新核对 Android/Web 构建路径
