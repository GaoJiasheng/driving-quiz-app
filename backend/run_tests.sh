#!/bin/bash

# 驾考刷刷后端单元测试脚本
# 使用方法: ./run_tests.sh

echo "=================================="
echo "  驾考刷刷后端单元测试"
echo "=================================="
echo ""

# 颜色定义
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 进入backend目录
cd "$(dirname "$0")"

echo "📦 当前目录: $(pwd)"
echo ""

# 检查Go是否安装
if ! command -v go &> /dev/null; then
    echo -e "${RED}❌ Go未安装，请先安装Go 1.21+${NC}"
    exit 1
fi

echo "✅ Go版本: $(go version)"
echo ""

# 运行所有测试
echo "=================================="
echo "📝 运行所有单元测试"
echo "=================================="
echo ""

go test ./... -v -cover

TEST_EXIT_CODE=$?

echo ""
echo "=================================="
echo "📊 测试覆盖率报告"
echo "=================================="
echo ""

# 生成覆盖率报告
go test ./... -coverprofile=coverage.out -covermode=count

if [ -f coverage.out ]; then
    echo ""
    echo "详细覆盖率："
    go tool cover -func=coverage.out
    
    echo ""
    echo "💡 生成HTML覆盖率报告..."
    go tool cover -html=coverage.out -o coverage.html
    echo "✅ 覆盖率报告已生成: coverage.html"
fi

echo ""
echo "=================================="
echo "⚡ 性能基准测试"
echo "=================================="
echo ""

go test ./... -bench=. -benchmem -run=^$ 2>/dev/null

echo ""
echo "=================================="
echo "📈 测试总结"
echo "=================================="
echo ""

if [ $TEST_EXIT_CODE -eq 0 ]; then
    echo -e "${GREEN}✅ 所有测试通过！${NC}"
    echo ""
    echo "生成的文件："
    echo "  - coverage.out   (覆盖率数据)"
    echo "  - coverage.html  (HTML覆盖率报告)"
    echo ""
    echo "查看覆盖率报告："
    echo "  open coverage.html"
    exit 0
else
    echo -e "${RED}❌ 测试失败！${NC}"
    exit 1
fi
