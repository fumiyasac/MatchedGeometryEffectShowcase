package handler

import (
	"net/http"

	"github.com/fumiyasac/gourmet-gallery-api/internal/usecase"
	"github.com/gin-gonic/gin"
)

type PickupHandler struct {
	uc usecase.PickupUseCase
}

func NewPickupHandler(uc usecase.PickupUseCase) *PickupHandler {
	return &PickupHandler{uc: uc}
}

// GetAll godoc
// @Summary      Get all pickup foods
// @Tags         pickup
// @Produce      json
// @Success      200  {array}   entity.PickupFood
// @Failure      500  {object}  map[string]string
// @Router       /api/v1/pickup_foods [get]
func (h *PickupHandler) GetAll(c *gin.Context) {
	foods, err := h.uc.GetAll()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, foods)
}
