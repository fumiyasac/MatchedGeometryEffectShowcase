package usecase

import (
	"github.com/fumiyasac/gourmet-gallery-api/internal/domain/entity"
	"github.com/fumiyasac/gourmet-gallery-api/internal/repository"
)

type GalleryUseCase interface {
	GetAll() ([]entity.GalleryPhoto, error)
	GetByID(id uint) (*entity.GalleryPhoto, error)
	GetByCategory(category string) ([]entity.GalleryPhoto, error)
}

type galleryUseCase struct {
	repo repository.GalleryRepository
}

func NewGalleryUseCase(repo repository.GalleryRepository) GalleryUseCase {
	return &galleryUseCase{repo: repo}
}

func (u *galleryUseCase) GetAll() ([]entity.GalleryPhoto, error) {
	return u.repo.FindAll()
}

func (u *galleryUseCase) GetByID(id uint) (*entity.GalleryPhoto, error) {
	return u.repo.FindByID(id)
}

func (u *galleryUseCase) GetByCategory(category string) ([]entity.GalleryPhoto, error) {
	return u.repo.FindByCategory(category)
}
