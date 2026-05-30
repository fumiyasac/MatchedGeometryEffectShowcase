package usecase

import (
	"github.com/fumiyasac/gourmet-gallery-api/internal/domain/entity"
	"github.com/fumiyasac/gourmet-gallery-api/internal/repository"
)

type PickupUseCase interface {
	GetAll() ([]entity.PickupFood, error)
}

type pickupUseCase struct {
	repo repository.PickupRepository
}

func NewPickupUseCase(repo repository.PickupRepository) PickupUseCase {
	return &pickupUseCase{repo: repo}
}

func (u *pickupUseCase) GetAll() ([]entity.PickupFood, error) {
	return u.repo.FindAll()
}
