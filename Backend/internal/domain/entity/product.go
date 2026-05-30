package entity

import "time"

type Product struct {
	ID                  uint        `gorm:"primaryKey;autoIncrement" json:"id"`
	IsPremium           bool        `gorm:"not null;default:false" json:"is_premium"`
	IsSale              bool        `gorm:"not null;default:false" json:"is_sale"`
	PercentSale         int         `gorm:"not null;default:0" json:"percent_sale"`
	RegularPrice        int         `gorm:"not null" json:"regular_price"`
	ProductName         string      `gorm:"type:varchar(255);not null" json:"product_name"`
	ProductSummary      string      `gorm:"type:varchar(512);not null" json:"product_summary"`
	ProductDescription  string      `gorm:"type:text;not null" json:"product_description"`
	ProductMainCategory string      `gorm:"type:varchar(64);not null" json:"product_main_category"`
	ProductSubCategory  string      `gorm:"type:varchar(64);not null" json:"product_sub_category"`
	ProductHashtags     StringSlice `gorm:"type:json;not null" json:"product_hashtags"`
	ImageName           string      `gorm:"type:varchar(255);not null" json:"image_name"`
	CreatedAt           time.Time   `json:"created_at"`
	UpdatedAt           time.Time   `json:"updated_at"`
}

func (Product) TableName() string {
	return "products"
}
