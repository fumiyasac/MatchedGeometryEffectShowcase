package entity

import "time"

type PickupFood struct {
	ID        uint      `gorm:"primaryKey;autoIncrement" json:"id"`
	Title     string    `gorm:"type:varchar(255);not null" json:"title"`
	ImageName string    `gorm:"type:varchar(255);not null" json:"image_name"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

func (PickupFood) TableName() string {
	return "pickup_foods"
}
