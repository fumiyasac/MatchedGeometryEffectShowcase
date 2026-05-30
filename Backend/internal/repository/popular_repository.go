package repository

import (
	"github.com/fumiyasac/gourmet-gallery-api/internal/domain/entity"
	"gorm.io/gorm"
)

type PopularRepository interface {
	FindAll() ([]entity.PopularArticle, error)
	FindByID(id uint) (*entity.PopularArticle, error)
	FindByMainCategory(category string) ([]entity.PopularArticle, error)
}

type popularRepository struct {
	db *gorm.DB
}

func NewPopularRepository(db *gorm.DB) PopularRepository {
	return &popularRepository{db: db}
}

func (r *popularRepository) FindAll() ([]entity.PopularArticle, error) {
	var articles []entity.PopularArticle
	if err := r.db.Order("id asc").Find(&articles).Error; err != nil {
		return nil, err
	}
	return articles, nil
}

func (r *popularRepository) FindByID(id uint) (*entity.PopularArticle, error) {
	var article entity.PopularArticle
	if err := r.db.First(&article, id).Error; err != nil {
		return nil, err
	}
	return &article, nil
}

func (r *popularRepository) FindByMainCategory(category string) ([]entity.PopularArticle, error) {
	var articles []entity.PopularArticle
	if err := r.db.Where("main_category = ?", category).Order("id asc").Find(&articles).Error; err != nil {
		return nil, err
	}
	return articles, nil
}
