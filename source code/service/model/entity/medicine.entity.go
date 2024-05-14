package entity

import (
	"gorm.io/gorm"
	"time"
)

type Medicine struct {
	ID      uint           `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Name    string         `json:"name"`
	Amount  int            `json:"amount"`
	Expired string         `json:"expired"`
	Reports []DoctorReport `gorm:"many2many:medicine_doctor_report;"`
	// medicine picture
	CreatedAt time.Time      `json:"created_at"`
	UpdatedAt time.Time      `json:"updated_at"`
	DeletedAt gorm.DeletedAt `json:"-" gorm:"index,column:deleted_at"`
}

func (m *Medicine) TableName() string {
	return "medicines"
}
