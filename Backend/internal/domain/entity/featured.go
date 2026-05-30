package entity

import "time"

type Featured struct {
	ID              uint      `gorm:"primaryKey;autoIncrement" json:"id"`
	Category        string    `gorm:"type:varchar(64);not null" json:"category"`
	Title           string    `gorm:"type:varchar(255);not null" json:"title"`
	CatchCopy       string    `gorm:"type:varchar(255);not null" json:"catch_copy"`
	DescriptionText string    `gorm:"type:text;not null" json:"description_text"`
	Rating          float32   `gorm:"type:decimal(3,1);not null;default:0.0" json:"rating"`
	ImageName       string    `gorm:"type:varchar(255);not null" json:"image_name"`
	CreatedAt       time.Time `json:"created_at"`
	UpdatedAt       time.Time `json:"updated_at"`
}

func (Featured) TableName() string {
	return "featured"
}
