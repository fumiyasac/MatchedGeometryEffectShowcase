package usecase

import (
	"github.com/fumiyasac/gourmet-gallery-api/internal/domain/entity"
	"github.com/fumiyasac/gourmet-gallery-api/internal/repository"
)

type PopularUseCase interface {
	GetAll() ([]entity.PopularArticle, error)
	GetByID(id uint) (*entity.PopularArticle, error)
}

type popularUseCase struct {
	repo repository.PopularRepository
}

func NewPopularUseCase(repo repository.PopularRepository) PopularUseCase {
	return &popularUseCase{repo: repo}
}

func (u *popularUseCase) GetAll() ([]entity.PopularArticle, error) {
	return u.repo.FindAll()
}

func (u *popularUseCase) GetByID(id uint) (*entity.PopularArticle, error) {
	return u.repo.FindByID(id)
}
