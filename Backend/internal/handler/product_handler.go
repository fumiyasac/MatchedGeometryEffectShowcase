package handler

import (
	"net/http"
	"strconv"

	"github.com/fumiyasac/gourmet-gallery-api/internal/usecase"
	"github.com/gin-gonic/gin"
)

type ProductHandler struct {
	uc usecase.ProductUseCase
}

func NewProductHandler(uc usecase.ProductUseCase) *ProductHandler {
	return &ProductHandler{uc: uc}
}

// GetAll godoc
// @Summary      Get all products
// @Tags         products
// @Produce      json
// @Success      200  {array}   entity.Product
// @Failure      500  {object}  map[string]string
// @Router       /api/v1/products [get]
func (h *ProductHandler) GetAll(c *gin.Context) {
	products, err := h.uc.GetAll()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, products)
}

// GetByID godoc
// @Summary      Get product by ID
// @Tags         products
// @Produce      json
// @Param        id  path  int  true  "Product ID"
// @Success      200  {object}  entity.Product
// @Failure      404  {object}  map[string]string
// @Router       /api/v1/products/{id} [get]
func (h *ProductHandler) GetByID(c *gin.Context) {
	id, err := strconv.ParseUint(c.Param("id"), 10, 64)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid id"})
		return
	}
	product, err := h.uc.GetByID(uint(id))
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"error": "not found"})
		return
	}
	c.JSON(http.StatusOK, product)
}
