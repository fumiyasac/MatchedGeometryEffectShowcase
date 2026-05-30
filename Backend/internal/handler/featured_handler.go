package handler

import (
	"net/http"

	"github.com/fumiyasac/gourmet-gallery-api/internal/repository"
	"github.com/gin-gonic/gin"
)

type FeaturedHandler struct {
	featuredRepo repository.FeaturedRepository
	newsRepo     repository.NewsRepository
}

func NewFeaturedHandler(featuredRepo repository.FeaturedRepository, newsRepo repository.NewsRepository) *FeaturedHandler {
	return &FeaturedHandler{featuredRepo: featuredRepo, newsRepo: newsRepo}
}

// GetFeatured godoc
// @Summary      Get all featured items
// @Tags         featured
// @Produce      json
// @Success      200  {array}   entity.Featured
// @Router       /api/v1/featured [get]
func (h *FeaturedHandler) GetFeatured(c *gin.Context) {
	items, err := h.featuredRepo.FindAll()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, items)
}

// GetNews godoc
// @Summary      Get all news
// @Tags         news
// @Produce      json
// @Param        category  query  string  false  "Filter by category"
// @Success      200  {array}   entity.News
// @Router       /api/v1/news [get]
func (h *FeaturedHandler) GetNews(c *gin.Context) {
	category := c.Query("category")
	if category != "" {
		items, err := h.newsRepo.FindByCategory(category)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, items)
		return
	}
	items, err := h.newsRepo.FindAll()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, items)
}
