# GitHub 同步检查清单

在将仓库同步到 GitHub 前，按下面顺序检查。

## 1. 敏感信息

- [ ] `opencode.json` 未提交到 Git
- [ ] `.env` / `*.env.local` 未提交到 Git
- [ ] Android 签名文件 `*.jks` 未提交到 Git
- [ ] `android/key.properties` 未提交到 Git
- [ ] README / 文档中没有粘贴真实密钥、Token、私有 URL

## 2. Flutter 工程完整性

当前仓库仍是“手动脚手架 + 业务代码”状态。

发布到 GitHub 前，建议确认以下平台目录是否存在：

- [ ] `android/`
- [ ] `ios/`
- [ ] `web/`
- [ ] `windows/`
- [ ] `linux/`
- [ ] `macos/`

如果缺失，GitHub Actions 中的构建步骤可能无法真正执行成功。

## 3. GitHub Actions

- [ ] 工作流文件位于 `.github/workflows/build.yml`
- [ ] `pubspec.yaml` 中依赖可正常解析
- [ ] 已确认工作流引用的 Flutter 版本可用
- [ ] 若使用签名发布，已在 GitHub Secrets 中配置对应变量

推荐 Secrets：

- `SIGN_KEYSTORE_PASSWORD`
- `SIGN_KEY_PASSWORD`

## 4. 文档入口

- [ ] `README.md` 可以说明项目用途、当前状态、目录结构
- [ ] `DEVELOPMENT_SPEC.md` 与当前实现一致
- [ ] `FEATURE_TRACKER.md` 状态已更新
- [ ] `docs/github-actions.md` 说明了构建脚本位置和限制

## 5. 提交前自检

有 Flutter 环境时，执行：

```bash
flutter pub get
flutter analyze
flutter test
```

如果平台目录已补齐，还建议执行：

```bash
flutter build apk --debug
flutter build web
```

## 6. 推荐同步顺序

1. 先提交文档、`lib/`、`pubspec.yaml`、`.github/workflows/`
2. 再补齐 Flutter 平台目录
3. 本地确认能跑通 `flutter analyze` / `flutter test`
4. 最后推送 GitHub，观察 Actions 执行结果
