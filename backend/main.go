package main

import (
	"log"

	"github.com/gin-gonic/gin"
	"github.com/gin-contrib/cors"
	"github.com/gavin/driving-quiz-app/backend/api"
)

func main() {
	log.Println("🚀 Starting DriveQuiz Backend Server...")

	// 初始化服务
	api.InitService("./data")

	// 创建 Gin 路由
	r := gin.Default()

	// CORS 配置
	r.Use(cors.New(cors.Config{
		AllowOrigins:     []string{"*"},
		AllowMethods:     []string{"GET", "POST", "PUT", "DELETE", "OPTIONS"},
		AllowHeaders:     []string{"Origin", "Content-Type", "Authorization"},
		ExposeHeaders:    []string{"Content-Length"},
		AllowCredentials: false,
	}))

	// API 路由组
	apiGroup := r.Group("/api")
	{
		// 健康检查
		apiGroup.GET("/health", api.HealthCheck)

		// 题库相关路由
		apiGroup.GET("/banks", api.GetBankList)
		apiGroup.GET("/banks/:id/download", api.DownloadBank)
	}

	// 启动服务
	port := ":8080"
	log.Printf("✅ Server is ready at http://localhost%s", port)
	log.Println("📚 Available endpoints:")
	log.Println("   - GET  /api/health")
	log.Println("   - GET  /api/banks")
	log.Println("   - GET  /api/banks/:id/download")
	
	if err := r.Run(port); err != nil {
		log.Fatalf("❌ Failed to start server: %v", err)
	}
}
