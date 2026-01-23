package utils

import (
	"go.uber.org/zap"
)

var Logger *zap.Logger

// InitLogger 初始化日志
func InitLogger(mode string) error {
	var err error
	
	if mode == "release" || mode == "production" {
		// 生产环境：JSON 格式
		Logger, err = zap.NewProduction()
	} else {
		// 开发环境：可读格式
		Logger, err = zap.NewDevelopment()
	}
	
	if err != nil {
		return err
	}
	
	return nil
}

// Info 日志
func Info(msg string, fields ...zap.Field) {
	if Logger != nil {
		Logger.Info(msg, fields...)
	}
}

// Error 日志
func Error(msg string, fields ...zap.Field) {
	if Logger != nil {
		Logger.Error(msg, fields...)
	}
}

// Debug 日志
func Debug(msg string, fields ...zap.Field) {
	if Logger != nil {
		Logger.Debug(msg, fields...)
	}
}

// Warn 日志
func Warn(msg string, fields ...zap.Field) {
	if Logger != nil {
		Logger.Warn(msg, fields...)
	}
}
