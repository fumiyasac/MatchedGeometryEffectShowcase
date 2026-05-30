package repository

import (
	"github.com/fumiyasac/gourmet-gallery-api/internal/domain/entity"
	"gorm.io/gorm"
)

type GalleryRepository interface {
	FindAll() ([]entity.GalleryPhoto, error)
	FindByID(id uint) (*entity.GalleryPhoto, error)
	FindByCategory(category string) ([]entity.GalleryPhoto, error)
}

type galleryRepository struct {
	db *gorm.DB
}

func NewGalleryRepository(db *gorm.DB) GalleryRepository {
	return &galleryRepository{db: db}
}

func (r *galleryRepository) FindAll() ([]entity.GalleryPhoto, error) {
	var photos []entity.GalleryPhoto
	if err := r.db.Order("id asc").Find(&photos).Error; err != nil {
		return nil, err
	}
	return photos, nil
}

func (r *galleryRepository) FindByID(id uint) (*entity.GalleryPhoto, error) {
	var photo entity.GalleryPhoto
	if err := r.db.First(&photo, id).Error; err != nil {
		return nil, err
	}
	return &photo, nil
}

func (r *galleryRepository) FindByCategory(category string) ([]entity.GalleryPhoto, error) {
	var photos []entity.GalleryPhoto
	if err := r.db.Where("category = ?", category).Order("id asc").Find(&photos).Error; err != nil {
		return nil, err
	}
	return photos, nil
}
