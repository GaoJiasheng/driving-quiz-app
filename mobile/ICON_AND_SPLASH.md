# 应用图标和启动页说明

## ✅ 已完成

### 🎨 应用图标
- ✅ 主图标（1024x1024px）
- ✅ Android Adaptive图标
- ✅ iOS图标（所有尺寸）
- ✅ macOS图标

**设计说明**：
- 蓝色渐变背景（#3B82F6 → #2563EB）
- 白色方向盘图标（象征驾驶）
- 简洁现代的设计风格

### 🚀 启动页（Splash Screen）
- ✅ Android启动页
- ✅ Android 12+适配
- ✅ iOS启动页
- ✅ 深色模式支持

**设计说明**：
- 蓝色背景（#3B82F6）
- 居中的白色方向盘图标
- 支持亮色/深色模式

## 📁 生成的文件

### 图标源文件
```
assets/images/
├── app_icon.png              # 主应用图标（1024x1024）
├── app_icon_foreground.png   # Android前景图标
└── splash_icon.png           # 启动页图标（512x512）
```

### Android
```
android/app/src/main/res/
├── mipmap-hdpi/ic_launcher.png
├── mipmap-mdpi/ic_launcher.png
├── mipmap-xhdpi/ic_launcher.png
├── mipmap-xxhdpi/ic_launcher.png
├── mipmap-xxxhdpi/ic_launcher.png
├── mipmap-*dpi/ic_launcher_foreground.png
├── drawable*/launch_background.xml
├── values*/colors.xml
└── values*/styles.xml
```

### iOS
```
ios/Runner/Assets.xcassets/
├── AppIcon.appiconset/
│   ├── Icon-App-*.png（各种尺寸）
│   └── Contents.json
└── LaunchImage.imageset/
    ├── LaunchImage*.png
    └── Contents.json
```

### macOS
```
macos/Runner/Assets.xcassets/AppIcon.appiconset/
├── app_icon_*.png（各种尺寸）
└── Contents.json
```

## 🎨 自定义图标

如果你想使用自己的图标设计：

### 方法1：使用在线工具
1. 访问 [Canva](https://www.canva.com/) 或 [Figma](https://www.figma.com/)
2. 创建 1024x1024px 的图标
3. 导出为PNG格式
4. 替换 `assets/images/app_icon.png`
5. 运行 `dart run flutter_launcher_icons`

### 方法2：重新运行生成脚本
```bash
# 编辑 create_icon.py 修改设计
# 然后运行：
python3 create_icon.py
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

### 方法3：手动替换
1. 准备以下文件：
   - `assets/images/app_icon.png` (1024x1024px)
   - `assets/images/app_icon_foreground.png` (1024x1024px, 透明背景)
   - `assets/images/splash_icon.png` (512x512px, 透明背景)

2. 运行生成命令：
```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## 🧪 测试

### 查看应用图标
1. 构建应用：`flutter build macos`
2. 在Finder中查看应用图标
3. 在不同设备上测试

### 查看启动页
1. 完全退出应用
2. 重新启动应用
3. 观察启动时的闪屏

## 📝 配置文件

### pubspec.yaml
```yaml
# 应用图标配置
flutter_launcher_icons:
  android: true
  ios: true
  image_path: "assets/images/app_icon.png"
  adaptive_icon_background: "#3B82F6"
  adaptive_icon_foreground: "assets/images/app_icon_foreground.png"
  
  macos:
    generate: true
    image_path: "assets/images/app_icon.png"
  
# 启动页配置
flutter_native_splash:
  color: "#3B82F6"
  image: assets/images/splash_icon.png
  android: true
  ios: true
  web: false
  
  android_12:
    image: assets/images/splash_icon.png
    color: "#3B82F6"
```

## 🎯 设计建议

### 应用图标设计原则
- ✅ 简洁明了，一目了然
- ✅ 在小尺寸下清晰可辨
- ✅ 独特，容易记忆
- ✅ 与品牌色调一致
- ✅ 避免过多细节

### 启动页设计原则
- ✅ 加载时间短（< 2秒）
- ✅ 与应用主题一致
- ✅ 简洁，不要放太多内容
- ✅ 支持深色模式

## 🔧 故障排除

### 图标没有更新
```bash
# 清理并重新构建
flutter clean
flutter pub get
dart run flutter_launcher_icons
flutter build macos
```

### 启动页没有显示
```bash
# 重新生成启动页
dart run flutter_native_splash:create

# 完全卸载应用后重新安装
flutter run
```

### macOS图标显示为默认图标
```bash
# 确保已生成macOS图标
dart run flutter_launcher_icons

# 重新构建
flutter build macos --release

# 清理DerivedData（如果还是不行）
rm -rf ~/Library/Developer/Xcode/DerivedData
```

## 📚 参考资源

- [Flutter App Icon Generator](https://www.appicon.co/)
- [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)
- [flutter_native_splash](https://pub.dev/packages/flutter_native_splash)
- [iOS图标规范](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- [Android图标规范](https://developer.android.com/distribute/google-play/resources/icon-design-specifications)

---

**创建时间**: 2026-01-23
**工具**: Python + Pillow + flutter_launcher_icons + flutter_native_splash
