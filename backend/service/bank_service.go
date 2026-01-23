package service

import (
	"encoding/json"
	"io/ioutil"
	"path/filepath"

	"github.com/gavin/driving-quiz-app/backend/model"
)

// BankService 题库服务
type BankService struct {
	dataDir string
}

// NewBankService 创建题库服务实例
func NewBankService(dataDir string) *BankService {
	return &BankService{
		dataDir: dataDir,
	}
}

// GetBankList 获取题库列表
func (s *BankService) GetBankList() ([]model.BankInfo, error) {
	filePath := filepath.Join(s.dataDir, "banks.json")
	data, err := ioutil.ReadFile(filePath)
	if err != nil {
		return nil, err
	}

	var response struct {
		Banks []model.BankInfo `json:"banks"`
	}
	
	if err := json.Unmarshal(data, &response); err != nil {
		return nil, err
	}

	return response.Banks, nil
}

// GetBankData 获取题库数据
func (s *BankService) GetBankData(bankID string) (*model.QuestionBank, error) {
	filePath := filepath.Join(s.dataDir, "banks", bankID+".json")
	data, err := ioutil.ReadFile(filePath)
	if err != nil {
		return nil, err
	}

	var bank model.QuestionBank
	if err := json.Unmarshal(data, &bank); err != nil {
		return nil, err
	}

	return &bank, nil
}

// GetBankDataRaw 获取题库原始数据（用于下载）
func (s *BankService) GetBankDataRaw(bankID string) ([]byte, error) {
	filePath := filepath.Join(s.dataDir, "banks", bankID+".json")
	return ioutil.ReadFile(filePath)
}
