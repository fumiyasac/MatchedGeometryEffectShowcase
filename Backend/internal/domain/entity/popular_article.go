package entity

import (
	"database/sql/driver"
	"encoding/json"
	"fmt"
	"time"
)

type StringSlice []string

func (s StringSlice) Value() (driver.Value, error) {
	b, err := json.Marshal(s)
	return string(b), err
}

func (s *StringSlice) Scan(src interface{}) error {
	var source string
	switch v := src.(type) {
	case []byte:
		source = string(v)
	case string:
		source = v
	default:
		return fmt.Errorf("unsupported type: %T", src)
	}
	return json.Unmarshal([]byte(source), s)
}

type PopularArticle struct {
	ID              uint        `gorm:"primaryKey;autoIncrement" json:"id"`
	Title           string      `gorm:"type:varchar(255);not null" json:"title"`
	ArticleText     string      `gorm:"type:text;not null" json:"article_text"`
	MainCategory    string      `gorm:"type:varchar(64);not null" json:"main_category"`
	SubCategory     string      `gorm:"type:varchar(64);not null" json:"sub_category"`
	Hashtags        StringSlice `gorm:"type:json;not null" json:"hashtags"`
	ImageName       string      `gorm:"type:varchar(255);not null" json:"image_name"`
	CreatedAt       time.Time   `json:"created_at"`
	UpdatedAt       time.Time   `json:"updated_at"`
}

func (PopularArticle) TableName() string {
	return "popular_articles"
}
