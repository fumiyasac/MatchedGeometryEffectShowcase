package handler

import (
	"net/http"
	"strconv"

	"github.com/fumiyasac/gourmet-gallery-api/internal/usecase"
	"github.com/gin-gonic/gin"
)

type GalleryHandler struct {
	uc usecase.GalleryUseCase
}

func NewGalleryHandler(uc usecase.GalleryUseCase) *GalleryHandler {
	return &GalleryHandler{uc: uc}
}

// GetAll godoc
// @Summary      Get all gallery photos
// @Tags         gallery
// @Produce      json
// @Param        category  query  string  false  "Filter by category"
// @Success      200  {array}   entity.GalleryPhoto
// @Failure      500  {object}  map[string]string
// @Router       /api/v1/gallery_photos [get]
func (h *GalleryHandler) GetAll(c *gin.Context) {
	category := c.Query("category")
	if category != "" {
		photos, err := h.uc.GetByCategory(category)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusOK, photos)
		return
	}
	photos, err := h.uc.GetAll()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, photos)
}

// GetByID godoc
// @Summary      Get gallery photo by ID
// @Tags         gallery
// @Produce      json
// @Param        id  path  int  true  "Gallery Photo ID"
// @Success      200  {object}  entity.GalleryPhoto
// @Failure      400  {object}  map[string]string
// @Failure      404  {object}  map[string]string
// @Router       /api/v1/gallery_photos/{id} [get]
func (h *GalleryHandler) GetByID(c *gin.Context) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid id"})
		return
	}
	photo, err := h.uc.GetByID(uint(id))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "not found"})
		return
	}
	c.JSON(http.StatusOK, photo)
}
