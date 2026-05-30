package repository

import (
	"github.com/fumiyasac/gourmet-gallery-api/internal/domain/entity"
	"gorm.io/gorm"
)

type FeaturedRepository interface {
	FindAll() ([]entity.Featured, error)
	FindByID(id uint) (*entity.Featured, error)
}

type featuredRepository struct {
	db *gorm.DB
}

func NewFeaturedRepository(db *gorm.DB) FeaturedRepository {
	return &featuredRepository{db: db}
}

func (r *featuredRepository) FindAll() ([]entity.Featured, error) {
	var items []entity.Featured
	if err := r.db.Order("id asc").Find(&items).Error; err != nil {
		return nil, err
	}
	return items, nil
}

func (r *featuredRepository) FindByID(id uint) (*entity.Featured, error) {
	var item entity.Featured
	if err := r.db.First(&item, id).Error; err != nil {
		return nil, err
	}
	return &item, nil
}

type NewsRepository interface {
	FindAll() ([]entity.News, error)
	FindByCategory(category string) ([]entity.News, error)
}

type newsRepository struct {
	db *gorm.DB
}

func NewNewsRepository(db *gorm.DB) NewsRepository {
	return &newsRepository{db: db}
}

func (r *newsRepository) FindAll() ([]entity.News, error) {
	var items []entity.News
	if err := r.db.Order("id asc").Find(&items).Error; err != nil {
		return nil, err
	}
	return items, nil
}

func (r *newsRepository) FindByCategory(category string) ([]entity.News, error) {
	var items []entity.News
	if err := r.db.Where("category = ?", category).Order("id asc").Find(&items).Error; err != nil {
		return nil, err
	}
	return items, nil
}
