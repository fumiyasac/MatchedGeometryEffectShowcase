package main

import (
	"log"
	"os"

	_ "github.com/fumiyasac/gourmet-gallery-api/docs"
	"github.com/fumiyasac/gourmet-gallery-api/internal/domain/entity"
	"github.com/fumiyasac/gourmet-gallery-api/internal/handler"
	"github.com/fumiyasac/gourmet-gallery-api/internal/infrastructure/mysql"
	"github.com/fumiyasac/gourmet-gallery-api/internal/repository"
	"github.com/fumiyasac/gourmet-gallery-api/internal/usecase"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

// @title           Gourmet Gallery API
// @version         1.0
// @description     美食ギャラリーiOSアプリ用バックエンドAPI
// @host            localhost:3000
// @BasePath        /
func main() {
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found, using environment variables")
	}

	db, err := mysql.NewDB()
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	// Auto migrate
	if err := db.AutoMigrate(
		&entity.GalleryPhoto{},
		&entity.PickupFood{},
		&entity.PopularArticle{},
		&entity.Product{},
		&entity.Featured{},
		&entity.News{},
	); err != nil {
		log.Fatalf("Failed to migrate: %v", err)
	}

	// Repositories
	galleryRepo := repository.NewGalleryRepository(db)
	pickupRepo := repository.NewPickupRepository(db)
	popularRepo := repository.NewPopularRepository(db)
	productRepo := repository.NewProductRepository(db)
	featuredRepo := repository.NewFeaturedRepository(db)
	newsRepo := repository.NewNewsRepository(db)

	// Use cases
	galleryUC := usecase.NewGalleryUseCase(galleryRepo)
	pickupUC := usecase.NewPickupUseCase(pickupRepo)
	popularUC := usecase.NewPopularUseCase(popularRepo)
	productUC := usecase.NewProductUseCase(productRepo)
	searchUC := usecase.NewSearchUseCase(productRepo, popularRepo, galleryRepo)

	// Handlers
	galleryH := handler.NewGalleryHandler(galleryUC)
	pickupH := handler.NewPickupHandler(pickupUC)
	popularH := handler.NewPopularHandler(popularUC)
	productH := handler.NewProductHandler(productUC)
	searchH := handler.NewSearchHandler(searchUC)
	featuredH := handler.NewFeaturedHandler(featuredRepo, newsRepo)

	_ = featuredRepo
	_ = newsRepo

	r := gin.Default()

	r.Use(func(c *gin.Context) {
		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
		c.Header("Access-Control-Allow-Headers", "Content-Type, Authorization")
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		c.Next()
	})

	v1 := r.Group("/api/v1")
	{
		v1.GET("/gallery_photos", galleryH.GetAll)
		v1.GET("/gallery_photos/:id", galleryH.GetByID)
		v1.GET("/pickup_foods", pickupH.GetAll)
		v1.GET("/popular_articles", popularH.GetAll)
		v1.GET("/popular_articles/:id", popularH.GetByID)
		v1.GET("/products", productH.GetAll)
		v1.GET("/products/:id", productH.GetByID)
		v1.GET("/featured", featuredH.GetFeatured)
		v1.GET("/news", featuredH.GetNews)
		v1.GET("/search", searchH.Search)
	}

	r.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	port := os.Getenv("PORT")
	if port == "" {
		port = "3000"
	}
	log.Printf("Server starting on port %s", port)
	if err := r.Run(":" + port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
