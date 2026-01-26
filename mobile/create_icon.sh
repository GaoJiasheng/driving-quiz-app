#!/bin/bash

# 创建应用图标的脚本
# 使用ImageMagick生成简单的应用图标

echo "🎨 创建应用图标..."

# 检查ImageMagick是否安装
if ! command -v convert &> /dev/null; then
    echo "⚠️  ImageMagick未安装"
    echo "📦 请安装ImageMagick: brew install imagemagick"
    echo ""
    echo "或者使用在线工具创建图标："
    echo "1. 访问 https://www.canva.com/"
    echo "2. 创建 1024x1024px 的图标"
    echo "3. 保存为 app_icon.png"
    echo "4. 将文件放到 assets/images/ 目录"
    exit 1
fi

# 创建assets/images目录
mkdir -p assets/images

# 生成主图标 (1024x1024, 蓝色渐变背景 + 白色方向盘图标)
convert -size 1024x1024 \
    gradient:'#3B82F6-#2563EB' \
    -gravity center \
    \( -size 512x512 xc:none \
       -fill white -stroke white -strokewidth 40 \
       -draw "circle 256,256 456,256" \
       -draw "circle 256,256 336,256" \
       -draw "line 256,256 256,56" \
       -draw "line 256,256 456,256" \
       -draw "line 256,256 56,406" \
    \) \
    -composite \
    assets/images/app_icon.png

echo "✅ 主图标已生成: assets/images/app_icon.png"

# 生成前景图标 (用于Android Adaptive Icon)
convert -size 1024x1024 xc:none \
    -fill white -stroke white -strokewidth 40 \
    -draw "circle 512,512 812,512" \
    -draw "circle 512,512 612,512" \
    -draw "line 512,512 512,212" \
    -draw "line 512,512 812,512" \
    -draw "line 512,512 212,712" \
    assets/images/app_icon_foreground.png

echo "✅ 前景图标已生成: assets/images/app_icon_foreground.png"

echo ""
echo "🚀 下一步："
echo "1. flutter pub get"
echo "2. dart run flutter_launcher_icons"
echo "3. dart run flutter_native_splash:create"
