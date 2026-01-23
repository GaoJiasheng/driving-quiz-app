package api

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/gavin/driving-quiz-app/backend/model"
)

func init() {
	// 设置Gin为测试模式
	gin.SetMode(gin.TestMode)
	// 初始化服务
	InitService("../data")
}

// TestHealthCheck 测试健康检查接口
func TestHealthCheck(t *testing.T) {
	router := gin.New()
	router.GET("/api/health", HealthCheck)

	req, _ := http.NewRequest("GET", "/api/health", nil)
	resp := httptest.NewRecorder()
	router.ServeHTTP(resp, req)

	// 验证状态码
	if resp.Code != http.StatusOK {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, resp.Code)
	}

	// 验证响应体
	var response map[string]interface{}
	if err := json.Unmarshal(resp.Body.Bytes(), &response); err != nil {
		t.Fatalf("Failed to parse response: %v", err)
	}

	if response["status"] != "ok" {
		t.Errorf("Expected status 'ok', got %v", response["status"])
	}

	if response["version"] != "1.0.0" {
		t.Errorf("Expected version '1.0.0', got %v", response["version"])
	}

	t.Logf("✅ Health check passed: %v", response)
}

// TestGetBankList 测试获取题库列表接口
func TestGetBankList(t *testing.T) {
	router := gin.New()
	router.GET("/api/banks", GetBankList)

	req, _ := http.NewRequest("GET", "/api/banks", nil)
	resp := httptest.NewRecorder()
	router.ServeHTTP(resp, req)

	// 验证状态码
	if resp.Code != http.StatusOK {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, resp.Code)
	}

	// 验证响应体
	var response struct {
		Code    int    `json:"code"`
		Message string `json:"message"`
		Data    struct {
			QuestionBanks []model.BankInfo `json:"question_banks"`
		} `json:"data"`
	}

	if err := json.Unmarshal(resp.Body.Bytes(), &response); err != nil {
		t.Fatalf("Failed to parse response: %v", err)
	}

	if response.Code != 200 {
		t.Errorf("Expected code 200, got %d", response.Code)
	}

	if response.Message != "success" {
		t.Errorf("Expected message 'success', got %s", response.Message)
	}

	if len(response.Data.QuestionBanks) == 0 {
		t.Error("Expected at least one bank, got 0")
	}

	// 验证题库字段
	if len(response.Data.QuestionBanks) > 0 {
		bank := response.Data.QuestionBanks[0]
		if bank.ID == "" {
			t.Error("Expected bank to have an ID")
		}
		if bank.Name == "" {
			t.Error("Expected bank to have a name")
		}
		t.Logf("✅ Bank: %s (%s) - %d questions", bank.Name, bank.ID, bank.TotalQuestions)
	}

	t.Logf("✅ Successfully retrieved %d banks", len(response.Data.QuestionBanks))
}

// TestDownloadBank 测试下载题库接口
func TestDownloadBank(t *testing.T) {
	router := gin.New()
	router.GET("/api/banks/:id/download", DownloadBank)

	// 测试Demo题库
	req, _ := http.NewRequest("GET", "/api/banks/demo_bank/download", nil)
	resp := httptest.NewRecorder()
	router.ServeHTTP(resp, req)

	// 验证状态码
	if resp.Code != http.StatusOK {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, resp.Code)
	}

	// 验证响应头
	contentType := resp.Header().Get("Content-Type")
	if contentType != "application/json" {
		t.Errorf("Expected Content-Type 'application/json', got %s", contentType)
	}

	contentDisposition := resp.Header().Get("Content-Disposition")
	if contentDisposition == "" {
		t.Error("Expected Content-Disposition header to be set")
	}

	// 验证响应体
	var bank model.QuestionBank
	if err := json.Unmarshal(resp.Body.Bytes(), &bank); err != nil {
		t.Fatalf("Failed to parse bank data: %v", err)
	}

	if bank.ID != "demo_bank" {
		t.Errorf("Expected bank ID 'demo_bank', got %s", bank.ID)
	}

	if len(bank.Questions) == 0 {
		t.Error("Expected bank to have questions")
	}

	t.Logf("✅ Successfully downloaded bank: %s with %d questions", bank.Name, len(bank.Questions))
}

// TestDownloadBankNotFound 测试下载不存在的题库
func TestDownloadBankNotFound(t *testing.T) {
	router := gin.New()
	router.GET("/api/banks/:id/download", DownloadBank)

	req, _ := http.NewRequest("GET", "/api/banks/non_existent_bank/download", nil)
	resp := httptest.NewRecorder()
	router.ServeHTTP(resp, req)

	// 验证状态码
	if resp.Code != http.StatusNotFound {
		t.Errorf("Expected status code %d, got %d", http.StatusNotFound, resp.Code)
	}

	// 验证错误响应
	var response map[string]interface{}
	if err := json.Unmarshal(resp.Body.Bytes(), &response); err != nil {
		t.Fatalf("Failed to parse error response: %v", err)
	}

	if response["code"].(float64) != 404 {
		t.Errorf("Expected code 404, got %v", response["code"])
	}

	t.Logf("✅ Correctly handled non-existent bank: %v", response["message"])
}

// TestCORS 测试CORS配置
func TestCORS(t *testing.T) {
	router := gin.New()
	router.GET("/api/health", HealthCheck)

	req, _ := http.NewRequest("GET", "/api/health", nil)
	req.Header.Set("Origin", "http://localhost:3000")
	resp := httptest.NewRecorder()
	router.ServeHTTP(resp, req)

	// 注意：这个测试在实际环境中需要CORS中间件
	// 这里只是验证API本身工作正常
	if resp.Code != http.StatusOK {
		t.Errorf("Expected status code %d, got %d", http.StatusOK, resp.Code)
	}

	t.Log("✅ CORS test passed (middleware not tested here)")
}

// TestMultipleBankDownloads 测试下载多个题库
func TestMultipleBankDownloads(t *testing.T) {
	router := gin.New()
	router.GET("/api/banks/:id/download", DownloadBank)

	bankIDs := []string{"demo_bank", "cn_subject1_v1"}

	for _, bankID := range bankIDs {
		req, _ := http.NewRequest("GET", "/api/banks/"+bankID+"/download", nil)
		resp := httptest.NewRecorder()
		router.ServeHTTP(resp, req)

		if resp.Code != http.StatusOK {
			t.Errorf("Failed to download bank %s: status code %d", bankID, resp.Code)
			continue
		}

		var bank model.QuestionBank
		if err := json.Unmarshal(resp.Body.Bytes(), &bank); err != nil {
			t.Errorf("Failed to parse bank %s: %v", bankID, err)
			continue
		}

		t.Logf("✅ Downloaded %s: %d questions", bankID, len(bank.Questions))
	}
}

// TestResponseFormat 测试响应格式一致性
func TestResponseFormat(t *testing.T) {
	router := gin.New()
	router.GET("/api/banks", GetBankList)

	req, _ := http.NewRequest("GET", "/api/banks", nil)
	resp := httptest.NewRecorder()
	router.ServeHTTP(resp, req)

	var response map[string]interface{}
	if err := json.Unmarshal(resp.Body.Bytes(), &response); err != nil {
		t.Fatalf("Failed to parse response: %v", err)
	}

	// 验证标准响应格式
	requiredFields := []string{"code", "message", "data"}
	for _, field := range requiredFields {
		if _, exists := response[field]; !exists {
			t.Errorf("Expected field '%s' in response", field)
		}
	}

	t.Log("✅ Response format is consistent")
}

// BenchmarkHealthCheck 性能测试：健康检查
func BenchmarkHealthCheck(b *testing.B) {
	router := gin.New()
	router.GET("/api/health", HealthCheck)

	req, _ := http.NewRequest("GET", "/api/health", nil)

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		resp := httptest.NewRecorder()
		router.ServeHTTP(resp, req)
	}
}

// BenchmarkGetBankList 性能测试：获取题库列表
func BenchmarkGetBankList(b *testing.B) {
	router := gin.New()
	router.GET("/api/banks", GetBankList)

	req, _ := http.NewRequest("GET", "/api/banks", nil)

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		resp := httptest.NewRecorder()
		router.ServeHTTP(resp, req)
	}
}

// BenchmarkDownloadBank 性能测试：下载题库
func BenchmarkDownloadBank(b *testing.B) {
	router := gin.New()
	router.GET("/api/banks/:id/download", DownloadBank)

	req, _ := http.NewRequest("GET", "/api/banks/demo_bank/download", nil)

	b.ResetTimer()
	for i := 0; i < b.N; i++ {
		resp := httptest.NewRecorder()
		router.ServeHTTP(resp, req)
	}
}
