#!/usr/bin/env python3
"""
创建应用图标的Python脚本
需要安装: pip install Pillow
"""

from PIL import Image, ImageDraw
import os

def create_app_icon():
    """创建主应用图标"""
    # 创建1024x1024的图像，蓝色渐变背景
    size = 1024
    img = Image.new('RGB', (size, size), color='#3B82F6')
    draw = ImageDraw.Draw(img)
    
    # 绘制渐变背景（简化版）
    for y in range(size):
        # 从#3B82F6到#2563EB的渐变
        r = int(59 - (59 - 37) * y / size)
        g = int(130 - (130 - 99) * y / size)
        b = int(246 - (246 - 235) * y / size)
        color = (r, g, b)
        draw.line([(0, y), (size, y)], fill=color)
    
    # 绘制方向盘图标
    center = size // 2
    radius = int(size * 0.35)
    thickness = int(size * 0.08)
    
    # 外圈
    draw.ellipse(
        [center - radius, center - radius, center + radius, center + radius],
        outline='white',
        width=thickness
    )
    
    # 内圈
    inner_radius = int(radius * 0.3)
    draw.ellipse(
        [center - inner_radius, center - inner_radius, 
         center + inner_radius, center + inner_radius],
        outline='white',
        width=thickness
    )
    
    # 三条辐条（简化版 - 十字和斜线）
    draw.line([(center, center - inner_radius), (center, center - radius)], 
              fill='white', width=thickness)
    draw.line([(center + inner_radius, center), (center + radius, center)], 
              fill='white', width=thickness)
    draw.line([(center - inner_radius * 0.7, center + inner_radius * 0.7), 
               (center - radius * 0.7, center + radius * 0.7)], 
              fill='white', width=thickness)
    
    # 确保目录存在
    os.makedirs('assets/images', exist_ok=True)
    
    # 保存
    img.save('assets/images/app_icon.png')
    print('✅ 主图标已生成: assets/images/app_icon.png')

def create_foreground_icon():
    """创建前景图标（用于Android Adaptive Icon）"""
    size = 1024
    img = Image.new('RGBA', (size, size), color=(0, 0, 0, 0))  # 透明背景
    draw = ImageDraw.Draw(img)
    
    # 绘制白色方向盘
    center = size // 2
    radius = int(size * 0.35)
    thickness = int(size * 0.08)
    
    # 外圈
    draw.ellipse(
        [center - radius, center - radius, center + radius, center + radius],
        outline='white',
        width=thickness
    )
    
    # 内圈
    inner_radius = int(radius * 0.3)
    draw.ellipse(
        [center - inner_radius, center - inner_radius, 
         center + inner_radius, center + inner_radius],
        outline='white',
        width=thickness
    )
    
    # 三条辐条
    draw.line([(center, center - inner_radius), (center, center - radius)], 
              fill='white', width=thickness)
    draw.line([(center + inner_radius, center), (center + radius, center)], 
              fill='white', width=thickness)
    draw.line([(center - inner_radius * 0.7, center + inner_radius * 0.7), 
               (center - radius * 0.7, center + radius * 0.7)], 
              fill='white', width=thickness)
    
    # 保存
    img.save('assets/images/app_icon_foreground.png')
    print('✅ 前景图标已生成: assets/images/app_icon_foreground.png')

def create_splash_image():
    """创建启动页图标"""
    size = 512
    img = Image.new('RGBA', (size, size), color=(0, 0, 0, 0))  # 透明背景
    draw = ImageDraw.Draw(img)
    
    # 绘制白色方向盘（较小）
    center = size // 2
    radius = int(size * 0.4)
    thickness = int(size * 0.1)
    
    # 外圈
    draw.ellipse(
        [center - radius, center - radius, center + radius, center + radius],
        outline='white',
        width=thickness
    )
    
    # 内圈
    inner_radius = int(radius * 0.3)
    draw.ellipse(
        [center - inner_radius, center - inner_radius, 
         center + inner_radius, center + inner_radius],
        outline='white',
        width=thickness
    )
    
    # 三条辐条
    draw.line([(center, center - inner_radius), (center, center - radius)], 
              fill='white', width=thickness)
    draw.line([(center + inner_radius, center), (center + radius, center)], 
              fill='white', width=thickness)
    draw.line([(center - inner_radius * 0.7, center + inner_radius * 0.7), 
               (center - radius * 0.7, center + radius * 0.7)], 
              fill='white', width=thickness)
    
    # 保存
    img.save('assets/images/splash_icon.png')
    print('✅ 启动页图标已生成: assets/images/splash_icon.png')

if __name__ == '__main__':
    print('🎨 开始生成应用图标...')
    print('')
    
    try:
        create_app_icon()
        create_foreground_icon()
        create_splash_image()
        print('')
        print('🚀 下一步：')
        print('1. flutter pub get')
        print('2. dart run flutter_launcher_icons')
        print('3. dart run flutter_native_splash:create')
    except ImportError:
        print('')
        print('⚠️  需要安装Pillow库')
        print('运行: pip3 install Pillow')
    except Exception as e:
        print(f'❌ 错误: {e}')
