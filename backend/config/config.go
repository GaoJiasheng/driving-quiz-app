package config

import (
	"os"
)

// Config 应用配置
type Config struct {
	Port        string
	DataDir     string
	Environment string
}

// LoadConfig 加载配置
func LoadConfig() *Config {
	return &Config{
		Port:        getEnv("PORT", "8080"),
		DataDir:     getEnv("DATA_DIR", "./data"),
		Environment: getEnv("GIN_MODE", "development"),
	}
}

// getEnv 获取环境变量，如果不存在则返回默认值
func getEnv(key, defaultValue string) string {
	value := os.Getenv(key)
	if value == "" {
		return defaultValue
	}
	return value
}
