package usecase

import (
	"github.com/fumiyasac/gourmet-gallery-api/internal/domain/entity"
	"github.com/fumiyasac/gourmet-gallery-api/internal/repository"
)

type ProductUseCase interface {
	GetAll() ([]entity.Product, error)
	GetByID(id uint) (*entity.Product, error)
}

type productUseCase struct {
	repo repository.ProductRepository
}

func NewProductUseCase(repo repository.ProductRepository) ProductUseCase {
	return &productUseCase{repo: repo}
}

func (u *productUseCase) GetAll() ([]entity.Product, error) {
	return u.repo.FindAll()
}

func (u *productUseCase) GetByID(id uint) (*entity.Product, error) {
	return u.repo.FindByID(id)
}
