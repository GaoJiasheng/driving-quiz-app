package api

import (
	"log"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/gavin/driving-quiz-app/backend/service"
)

var bankService *service.BankService

// InitService 初始化服务
func InitService(dataDir string) {
	bankService = service.NewBankService(dataDir)
	log.Println("✅ BankService initialized")
}

// GetBankList 获取题库列表
// GET /api/banks
func GetBankList(c *gin.Context) {
	banks, err := bankService.GetBankList()
	if err != nil {
		log.Printf("❌ Failed to get bank list: %v", err)
		c.JSON(http.StatusInternalServerError, gin.H{
			"code":    500,
			"message": "Failed to get bank list",
			"error":   err.Error(),
		})
		return
	}

	log.Printf("✅ Successfully retrieved %d banks", len(banks))
	c.JSON(http.StatusOK, gin.H{
		"code":    200,
		"message": "success",
		"data": gin.H{
			"question_banks": banks,
		},
	})
}

// DownloadBank 下载题库
// GET /api/banks/:id/download
func DownloadBank(c *gin.Context) {
	bankID := c.Param("id")
	log.Printf("📥 Downloading bank: %s", bankID)

	// 获取题库原始数据
	data, err := bankService.GetBankDataRaw(bankID)
	if err != nil {
		log.Printf("❌ Bank not found: %s", bankID)
		c.JSON(http.StatusNotFound, gin.H{
			"code":    404,
			"message": "Bank not found",
			"error":   err.Error(),
		})
		return
	}

	// 设置响应头
	c.Header("Content-Type", "application/json")
	c.Header("Content-Disposition", "attachment; filename="+bankID+".json")

	log.Printf("✅ Successfully downloaded bank: %s (%d bytes)", bankID, len(data))
	c.Data(http.StatusOK, "application/json", data)
}

// HealthCheck 健康检查
// GET /api/health
func HealthCheck(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status":  "ok",
		"message": "DriveQuiz Backend API is running",
		"version": "1.0.0",
	})
}
