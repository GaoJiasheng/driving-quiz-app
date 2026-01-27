#!/bin/bash

# 在不同iPhone模拟器上测试应用的脚本

echo "🚀 iOS模拟器测试助手"
echo "=================="
echo ""

# 检查可用的iOS模拟器
echo "📱 可用的iPhone模拟器："
echo ""
xcrun simctl list devices | grep "iPhone" | grep "Shutdown\|Booted" | nl

echo ""
echo "请选择测试方式："
echo ""
echo "1) 在iPhone 17 Pro上运行"
echo "2) 在iPhone 17 Pro Max上运行"
echo "3) 在iPhone Air上运行"
echo "4) 在iPhone 17上运行"
echo "5) 在iPhone 16e上运行"
echo "6) 依次在所有设备上测试（自动化）"
echo ""

read -p "请输入选项 (1-6): " choice

case $choice in
  1)
    echo "启动 iPhone 17 Pro..."
    xcrun simctl boot "iPhone 17 Pro" 2>/dev/null || echo "设备已运行"
    open -a Simulator
    sleep 3
    echo "运行应用..."
    cd "$(dirname "$0")" && flutter run -d "iPhone 17 Pro"
    ;;
  2)
    echo "启动 iPhone 17 Pro Max..."
    xcrun simctl boot "iPhone 17 Pro Max" 2>/dev/null || echo "设备已运行"
    open -a Simulator
    sleep 3
    echo "运行应用..."
    cd "$(dirname "$0")" && flutter run -d "iPhone 17 Pro Max"
    ;;
  3)
    echo "启动 iPhone Air..."
    xcrun simctl boot "iPhone Air" 2>/dev/null || echo "设备已运行"
    open -a Simulator
    sleep 3
    echo "运行应用..."
    cd "$(dirname "$0")" && flutter run -d "iPhone Air"
    ;;
  4)
    echo "启动 iPhone 17..."
    xcrun simctl boot "iPhone 17" 2>/dev/null || echo "设备已运行"
    open -a Simulator
    sleep 3
    echo "运行应用..."
    cd "$(dirname "$0")" && flutter run -d "iPhone 17"
    ;;
  5)
    echo "启动 iPhone 16e..."
    xcrun simctl boot "iPhone 16e" 2>/dev/null || echo "设备已运行"
    open -a Simulator
    sleep 3
    echo "运行应用..."
    cd "$(dirname "$0")" && flutter run -d "iPhone 16e"
    ;;
  6)
    echo "🤖 自动化测试模式"
    echo "将依次在所有设备上启动应用并截图"
    
    devices=("iPhone 17 Pro" "iPhone 17 Pro Max" "iPhone Air" "iPhone 17" "iPhone 16e")
    
    for device in "${devices[@]}"; do
      echo ""
      echo "📱 测试设备: $device"
      echo "------------------------"
      
      # 关闭所有模拟器
      xcrun simctl shutdown all 2>/dev/null
      
      # 启动目标设备
      xcrun simctl boot "$device" 2>/dev/null
      open -a Simulator
      sleep 5
      
      # 运行应用
      echo "运行应用..."
      cd "$(dirname "$0")" && flutter run -d "$device" &
      PID=$!
      
      # 等待应用启动
      sleep 15
      
      # 截图
      mkdir -p screenshots
      timestamp=$(date +%Y%m%d_%H%M%S)
      screenshot_path="screenshots/${device// /_}_${timestamp}.png"
      xcrun simctl io "$device" screenshot "$screenshot_path"
      echo "✅ 截图保存到: $screenshot_path"
      
      # 停止应用
      kill $PID 2>/dev/null
      sleep 2
    done
    
    echo ""
    echo "✅ 所有设备测试完成！"
    echo "📸 截图保存在 screenshots/ 目录"
    ;;
  *)
    echo "无效选项"
    exit 1
    ;;
esac
