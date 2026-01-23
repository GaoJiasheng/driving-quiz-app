package service

import (
	"encoding/json"
	"os"
	"path/filepath"
	"testing"

	"github.com/gavin/driving-quiz-app/backend/model"
)

// TestNewBankService 测试创建服务实例
func TestNewBankService(t *testing.T) {
	dataDir := "../data"
	service := NewBankService(dataDir)

	if service == nil {
		t.Fatal("Expected service to be created, got nil")
	}

	if service.dataDir != dataDir {
		t.Errorf("Expected dataDir to be %s, got %s", dataDir, service.dataDir)
	}
}

// TestGetBankList 测试获取题库列表
func TestGetBankList(t *testing.T) {
	dataDir := "../data"
	service := NewBankService(dataDir)

	banks, err := service.GetBankList()
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if len(banks) == 0 {
		t.Error("Expected at least one bank, got 0")
	}

	// 验证第一个题库的字段
	if len(banks) > 0 {
		bank := banks[0]
		if bank.ID == "" {
			t.Error("Expected bank to have an ID")
		}
		if bank.Name == "" {
			t.Error("Expected bank to have a name")
		}
		if bank.Version == "" {
			t.Error("Expected bank to have a version")
		}
		if bank.TotalQuestions == 0 {
			t.Error("Expected bank to have questions")
		}
	}

	t.Logf("✅ Successfully retrieved %d banks", len(banks))
}

// TestGetBankListInvalidPath 测试无效路径
func TestGetBankListInvalidPath(t *testing.T) {
	dataDir := "./invalid_path"
	service := NewBankService(dataDir)

	_, err := service.GetBankList()
	if err == nil {
		t.Error("Expected error for invalid path, got nil")
	}

	t.Logf("✅ Correctly handled invalid path: %v", err)
}

// TestGetBankData 测试获取题库数据
func TestGetBankData(t *testing.T) {
	dataDir := "../data"
	service := NewBankService(dataDir)

	// 测试Demo题库
	bankID := "demo_bank"
	bank, err := service.GetBankData(bankID)
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if bank == nil {
		t.Fatal("Expected bank data, got nil")
	}

	if bank.ID != bankID {
		t.Errorf("Expected bank ID to be %s, got %s", bankID, bank.ID)
	}

	if len(bank.Questions) == 0 {
		t.Error("Expected bank to have questions")
	}

	// 验证题目结构
	if len(bank.Questions) > 0 {
		question := bank.Questions[0]
		if question.ID == "" {
			t.Error("Expected question to have an ID")
		}
		if question.Type == "" {
			t.Error("Expected question to have a type")
		}
		if question.Question == "" {
			t.Error("Expected question to have content")
		}
		if len(question.Options) == 0 {
			t.Error("Expected question to have options")
		}
		if len(question.Answer) == 0 {
			t.Error("Expected question to have an answer")
		}
	}

	t.Logf("✅ Successfully retrieved bank: %s with %d questions", bank.Name, len(bank.Questions))
}

// TestGetBankDataNotFound 测试获取不存在的题库
func TestGetBankDataNotFound(t *testing.T) {
	dataDir := "../data"
	service := NewBankService(dataDir)

	bankID := "non_existent_bank"
	_, err := service.GetBankData(bankID)
	if err == nil {
		t.Error("Expected error for non-existent bank, got nil")
	}

	t.Logf("✅ Correctly handled non-existent bank: %v", err)
}

// TestGetBankDataRaw 测试获取原始题库数据
func TestGetBankDataRaw(t *testing.T) {
	dataDir := "../data"
	service := NewBankService(dataDir)

	bankID := "demo_bank"
	data, err := service.GetBankDataRaw(bankID)
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if len(data) == 0 {
		t.Error("Expected raw data, got empty")
	}

	// 验证是否为有效JSON
	var bank model.QuestionBank
	if err := json.Unmarshal(data, &bank); err != nil {
		t.Errorf("Expected valid JSON, got error: %v", err)
	}

	t.Logf("✅ Successfully retrieved raw data: %d bytes", len(data))
}

// TestGetBankDataRawNotFound 测试获取不存在的原始数据
func TestGetBankDataRawNotFound(t *testing.T) {
	dataDir := "../data"
	service := NewBankService(dataDir)

	bankID := "non_existent_bank"
	_, err := service.GetBankDataRaw(bankID)
	if err == nil {
		t.Error("Expected error for non-existent bank, got nil")
	}

	t.Logf("✅ Correctly handled non-existent raw data: %v", err)
}

// TestQuestionTypes 测试不同题型
func TestQuestionTypes(t *testing.T) {
	dataDir := "../data"
	service := NewBankService(dataDir)

	bank, err := service.GetBankData("demo_bank")
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	typeCounts := make(map[string]int)
	for _, q := range bank.Questions {
		typeCounts[q.Type]++
	}

	// 验证题型
	expectedTypes := []string{"single", "multiple", "judge"}
	for _, expectedType := range expectedTypes {
		if count, exists := typeCounts[expectedType]; exists {
			t.Logf("✅ Found %d questions of type: %s", count, expectedType)
		} else {
			t.Logf("⚠️  No questions of type: %s", expectedType)
		}
	}

	// 验证单选题答案格式
	for _, q := range bank.Questions {
		if q.Type == "single" || q.Type == "judge" {
			if len(q.Answer) != 1 {
				t.Errorf("Question %s: single/judge question should have 1 answer, got %d", q.ID, len(q.Answer))
			}
		}
	}

	t.Logf("✅ Question type validation passed")
}

// BenchmarkGetBankList 性能测试：获取题库列表
func BenchmarkGetBankList(b *testing.B) {
	dataDir := "../data"
	service := NewBankService(dataDir)

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_, _ = service.GetBankList()
	}
}

// BenchmarkGetBankData 性能测试：获取题库数据
func BenchmarkGetBankData(b *testing.B) {
	dataDir := "../data"
	service := NewBankService(dataDir)

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		_, _ = service.GetBankData("demo_bank")
	}
}

// TestDataIntegrity 测试数据完整性
func TestDataIntegrity(t *testing.T) {
	dataDir := "../data"

	// 检查data目录是否存在
	if _, err := os.Stat(dataDir); os.IsNotExist(err) {
		t.Fatal("Data directory does not exist")
	}

	// 检查banks.json是否存在
	banksFile := filepath.Join(dataDir, "banks.json")
	if _, err := os.Stat(banksFile); os.IsNotExist(err) {
		t.Fatal("banks.json does not exist")
	}

	// 检查banks目录是否存在
	banksDir := filepath.Join(dataDir, "banks")
	if _, err := os.Stat(banksDir); os.IsNotExist(err) {
		t.Fatal("banks directory does not exist")
	}

	t.Log("✅ Data directory structure is valid")
}
