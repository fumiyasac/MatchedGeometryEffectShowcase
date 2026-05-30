package handler

import (
	"net/http"
	"strconv"

	"github.com/fumiyasac/gourmet-gallery-api/internal/usecase"
	"github.com/gin-gonic/gin"
)

type PopularHandler struct {
	uc usecase.PopularUseCase
}

func NewPopularHandler(uc usecase.PopularUseCase) *PopularHandler {
	return &PopularHandler{uc: uc}
}

// GetAll godoc
// @Summary      Get all popular articles
// @Tags         popular
// @Produce      json
// @Success      200  {array}   entity.PopularArticle
// @Failure      500  {object}  map[string]string
// @Router       /api/v1/popular_articles [get]
func (h *PopularHandler) GetAll(c *gin.Context) {
	articles, err := h.uc.GetAll()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, articles)
}

// GetByID godoc
// @Summary      Get popular article by ID
// @Tags         popular
// @Produce      json
// @Param        id  path  int  true  "Article ID"
// @Success      200  {object}  entity.PopularArticle
// @Failure      404  {object}  map[string]string
// @Router       /api/v1/popular_articles/{id} [get]
func (h *PopularHandler) GetByID(c *gin.Context) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid id"})
		return
	}
	article, err := h.uc.GetByID(uint(id))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "not found"})
		return
	}
	c.JSON(http.StatusOK, article)
}
