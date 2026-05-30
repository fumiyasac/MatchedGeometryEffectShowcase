package usecase

import (
	"github.com/fumiyasac/gourmet-gallery-api/internal/domain/entity"
	"github.com/fumiyasac/gourmet-gallery-api/internal/repository"
)

type SearchResult struct {
	Products       []entity.Product        `json:"products"`
	PopularArticles []entity.PopularArticle `json:"popular_articles"`
	GalleryPhotos  []entity.GalleryPhoto   `json:"gallery_photos"`
}

type SearchUseCase interface {
	Search(params repository.ProductSearchParams) (*SearchResult, error)
}

type searchUseCase struct {
	productRepo repository.ProductRepository
	popularRepo repository.PopularRepository
	galleryRepo repository.GalleryRepository
}

func NewSearchUseCase(
	productRepo repository.ProductRepository,
	popularRepo repository.PopularRepository,
	galleryRepo repository.GalleryRepository,
) SearchUseCase {
	return &searchUseCase{
		productRepo: productRepo,
		popularRepo: popularRepo,
		galleryRepo: galleryRepo,
	}
}

func (u *searchUseCase) Search(params repository.ProductSearchParams) (*SearchResult, error) {
	products, err := u.productRepo.Search(params)
	if err != nil {
		return nil, err
	}

	var popularArticles []entity.PopularArticle
	if params.Keyword != "" {
		all, err := u.popularRepo.FindAll()
		if err != nil {
			return nil, err
		}
		for _, a := range all {
			if containsKeyword(a.Title, params.Keyword) || containsKeyword(a.ArticleText, params.Keyword) {
				popularArticles = append(popularArticles, a)
			}
		}
	}

	var galleryPhotos []entity.GalleryPhoto
	if params.MainCategory != "" {
		galleryPhotos, err = u.galleryRepo.FindByCategory(params.MainCategory)
		if err != nil {
			return nil, err
		}
	}

	return &SearchResult{
		Products:        products,
		PopularArticles: popularArticles,
		GalleryPhotos:   galleryPhotos,
	}, nil
}

func containsKeyword(text, keyword string) bool {
	return len(text) > 0 && len(keyword) > 0 &&
		(len(text) >= len(keyword)) &&
		(text == keyword || containsSubstring(text, keyword))
}

func containsSubstring(s, sub string) bool {
	for i := 0; i <= len(s)-len(sub); i++ {
		if s[i:i+len(sub)] == sub {
			return true
		}
	}
	return false
}
