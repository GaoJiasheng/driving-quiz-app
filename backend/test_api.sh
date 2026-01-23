#!/bin/bash

# 驾考刷刷后端API测试脚本
# 使用方法: ./test_api.sh

BASE_URL="http://localhost:8080"

echo "=================================="
echo "  驾考刷刷后端API测试"
echo "=================================="
echo ""

# 测试健康检查
echo "📍 测试 1: 健康检查"
echo "GET $BASE_URL/api/health"
echo "---"
curl -s $BASE_URL/api/health | jq '.'
echo ""
echo ""

# 测试题库列表
echo "📍 测试 2: 获取题库列表"
echo "GET $BASE_URL/api/banks"
echo "---"
curl -s $BASE_URL/api/banks | jq '.'
echo ""
echo ""

# 测试下载Demo题库
echo "📍 测试 3: 下载Demo题库"
echo "GET $BASE_URL/api/banks/demo_bank/download"
echo "---"
curl -s $BASE_URL/api/banks/demo_bank/download | jq '.id, .name, .total_questions, .questions[0]'
echo ""
echo ""

# 测试下载科目一题库
echo "📍 测试 4: 下载科目一题库"
echo "GET $BASE_URL/api/banks/cn_subject1_v1/download"
echo "---"
curl -s $BASE_URL/api/banks/cn_subject1_v1/download | jq '.id, .name, .total_questions, .questions[0]'
echo ""
echo ""

# 测试不存在的题库
echo "📍 测试 5: 下载不存在的题库（错误处理测试）"
echo "GET $BASE_URL/api/banks/not_exist/download"
echo "---"
curl -s $BASE_URL/api/banks/not_exist/download | jq '.'
echo ""
echo ""

echo "=================================="
echo "  测试完成！"
echo "=================================="
