package entity

import "time"

type GalleryPhoto struct {
	ID              uint      `gorm:"primaryKey;autoIncrement" json:"id"`
	Category        string    `gorm:"type:varchar(64);not null" json:"category"`
	Title           string    `gorm:"type:varchar(255);not null" json:"title"`
	CatchCopy       string    `gorm:"type:varchar(255);not null" json:"catch_copy"`
	DescriptionText string    `gorm:"type:text;not null" json:"description_text"`
	ImageName       string    `gorm:"type:varchar(255);not null" json:"image_name"`
	CreatedAt       time.Time `json:"created_at"`
	UpdatedAt       time.Time `json:"updated_at"`
}

func (GalleryPhoto) TableName() string {
	return "gallery_photos"
}
