package repository

import (
	"github.com/fumiyasac/gourmet-gallery-api/internal/domain/entity"
	"gorm.io/gorm"
)

type ProductSearchParams struct {
	Keyword     string
	MainCategory string
	SubCategory  string
	MinPrice    int
	MaxPrice    int
	IsPremium   *bool
	IsSale      *bool
	SortBy      string
}

type ProductRepository interface {
	FindAll() ([]entity.Product, error)
	FindByID(id uint) (*entity.Product, error)
	Search(params ProductSearchParams) ([]entity.Product, error)
}

type productRepository struct {
	db *gorm.DB
}

func NewProductRepository(db *gorm.DB) ProductRepository {
	return &productRepository{db: db}
}

func (r *productRepository) FindAll() ([]entity.Product, error) {
	var products []entity.Product
	if err := r.db.Order("id asc").Find(&products).Error; err != nil {
		return nil, err
	}
	return products, nil
}

func (r *productRepository) FindByID(id uint) (*entity.Product, error) {
	var product entity.Product
	if err := r.db.First(&product, id).Error; err != nil {
		return nil, err
	}
	return &product, nil
}

func (r *productRepository) Search(params ProductSearchParams) ([]entity.Product, error) {
	var products []entity.Product
	query := r.db.Model(&entity.Product{})

	if params.Keyword != "" {
		like := "%" + params.Keyword + "%"
		query = query.Where("product_name LIKE ? OR product_summary LIKE ? OR product_description LIKE ?", like, like, like)
	}
	if params.MainCategory != "" {
		query = query.Where("product_main_category = ?", params.MainCategory)
	}
	if params.SubCategory != "" {
		query = query.Where("product_sub_category = ?", params.SubCategory)
	}
	if params.MinPrice > 0 {
		query = query.Where("regular_price >= ?", params.MinPrice)
	}
	if params.MaxPrice > 0 {
		query = query.Where("regular_price <= ?", params.MaxPrice)
	}
	if params.IsPremium != nil {
		query = query.Where("is_premium = ?", *params.IsPremium)
	}
	if params.IsSale != nil {
		query = query.Where("is_sale = ?", *params.IsSale)
	}

	switch params.SortBy {
	case "price_asc":
		query = query.Order("regular_price asc")
	case "price_desc":
		query = query.Order("regular_price desc")
	case "newest":
		query = query.Order("created_at desc")
	default:
		query = query.Order("id asc")
	}

	if err := query.Find(&products).Error; err != nil {
		return nil, err
	}
	return products, nil
}
