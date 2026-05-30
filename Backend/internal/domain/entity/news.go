package entity

import "time"

type News struct {
	ID              uint      `gorm:"primaryKey;autoIncrement" json:"id"`
	Category        string    `gorm:"type:varchar(64);not null" json:"category"`
	Title           string    `gorm:"type:varchar(255);not null" json:"title"`
	DescriptionText string    `gorm:"type:text;not null" json:"description_text"`
	ImageName       string    `gorm:"type:varchar(255);not null" json:"image_name"`
	CreatedAt       time.Time `json:"created_at"`
	UpdatedAt       time.Time `json:"updated_at"`
}

func (News) TableName() string {
	return "news"
}
