package model

import "time"

// BankInfo 题库信息（元数据）
type BankInfo struct {
	ID              string    `json:"id"`
	Name            string    `json:"name"`
	Description     string    `json:"description"`
	TotalQuestions  int       `json:"total_questions"`
	Version         string    `json:"version"`
	Language        string    `json:"language"`
	Size            int64     `json:"size"`
	DownloadURL     string    `json:"download_url,omitempty"`
	UpdatedAt       time.Time `json:"updated_at"`
}

// QuestionBank 完整题库数据
type QuestionBank struct {
	ID              string     `json:"id"`
	Name            string     `json:"name"`
	Version         string     `json:"version"`
	Description     string     `json:"description"`
	TotalQuestions  int        `json:"total_questions"`
	CreatedAt       time.Time  `json:"created_at"`
	UpdatedAt       time.Time  `json:"updated_at"`
	Language        string     `json:"language"`
	Questions       []Question `json:"questions"`
}

// Question 题目
type Question struct {
	ID          string   `json:"id"`
	Type        string   `json:"type"` // single, multiple, judge
	Question    string   `json:"question"`
	Image       string   `json:"image,omitempty"`
	Options     []string `json:"options"`
	Answer      []int    `json:"answer"`
	Explanation string   `json:"explanation"`
	Chapter     string   `json:"chapter,omitempty"`
}

// BankListResponse 题库列表响应
type BankListResponse struct {
	Code    int    `json:"code"`
	Message string `json:"message"`
	Data    struct {
		QuestionBanks []BankInfo `json:"question_banks"`
	} `json:"data"`
}
