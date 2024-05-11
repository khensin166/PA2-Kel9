package entity

import (
	"gorm.io/gorm"
	"time"
)

type User struct {
	ID       uint   `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Name     string `json:"name"`
	Age      int    `json:"age"`
	Weight   int    `json:"weight"`
	Height   int    `json:"height"`
	NIK      int    `json:"nik"`
	Birthday string `json:"birthday"`
	Gender   string `json:"gender"`
	Address  string `json:"address"`
	Phone    string `json:"phone"`
	Username string `json:"username" gorm:"unique"`
	Password string `json:"password" gorm:"column:password"`
	Role     int    `json:"role"`
	//PROFILE PICTURE
	Appointments   []Appointment    `json:"-" gorm:"foreignKey:RequestedID"`
	MedicalHistory []MedicalHistory `json:"-"`
	NurseReport    *NurseReport     `json:"-" gorm:"foreignKey:PatientID"`
	CreatedAt      time.Time        `json:"created_at"`
	UpdatedAt      time.Time        `json:"updated_at"`
	DeletedAt      gorm.DeletedAt   `json:"-" gorm:"index,column:deleted_at"`
}

type UserResponse struct {
	ID       uint   `json:"id" gorm:"primaryKey;AUTO_INCREMENT"`
	Name     string `json:"name"`
	Age      int    `json:"age"`
	Weight   int    `json:"weight"`
	Height   int    `json:"height"`
	NIK      int    `json:"nik"`
	Birthday string `json:"birthday"`
	Gender   string `json:"gender"`
	Address  string `json:"address"`
	Phone    string `json:"phone"`
	Username string `json:"username" gorm:"unique"`
	Password string `json:"password" gorm:"column:password"`
	Role     int    `json:"role"`
}

func (UserResponse) TableName() string {
	return "users"
}
