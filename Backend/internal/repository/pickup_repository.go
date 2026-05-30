package repository

import (
	"github.com/fumiyasac/gourmet-gallery-api/internal/domain/entity"
	"gorm.io/gorm"
)

type PickupRepository interface {
	FindAll() ([]entity.PickupFood, error)
}

type pickupRepository struct {
	db *gorm.DB
}

func NewPickupRepository(db *gorm.DB) PickupRepository {
	return &pickupRepository{db: db}
}

func (r *pickupRepository) FindAll() ([]entity.PickupFood, error) {
	var foods []entity.PickupFood
	if err := r.db.Order("id asc").Find(&foods).Error; err != nil {
		return nil, err
	}
	return foods, nil
}
