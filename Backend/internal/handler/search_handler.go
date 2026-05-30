package handler

import (
	"net/http"
	"strconv"

	"github.com/fumiyasac/gourmet-gallery-api/internal/repository"
	"github.com/fumiyasac/gourmet-gallery-api/internal/usecase"
	"github.com/gin-gonic/gin"
)

type SearchHandler struct {
	uc usecase.SearchUseCase
}

func NewSearchHandler(uc usecase.SearchUseCase) *SearchHandler {
	return &SearchHandler{uc: uc}
}

// Search godoc
// @Summary      Search across all content
// @Tags         search
// @Produce      json
// @Param        keyword       query  string  false  "Search keyword"
// @Param        main_category query  string  false  "Main category filter"
// @Param        sub_category  query  string  false  "Sub category filter"
// @Param        min_price     query  int     false  "Minimum price"
// @Param        max_price     query  int     false  "Maximum price"
// @Param        is_premium    query  bool    false  "Premium filter"
// @Param        is_sale       query  bool    false  "Sale filter"
// @Param        sort_by       query  string  false  "Sort: popular, newest, price_asc, price_desc"
// @Success      200  {object}  usecase.SearchResult
// @Failure      500  {object}  map[string]string
// @Router       /api/v1/search [get]
func (h *SearchHandler) Search(c *gin.Context) {
	params := repository.ProductSearchParams{
		Keyword:      c.Query("keyword"),
		MainCategory: c.Query("main_category"),
		SubCategory:  c.Query("sub_category"),
		SortBy:       c.Query("sort_by"),
	}

	if v := c.Query("min_price"); v != "" {
		if n, err := strconv.Atoi(v); err == nil {
			params.MinPrice = n
		}
	}
	if v := c.Query("max_price"); v != "" {
		if n, err := strconv.Atoi(v); err == nil {
			params.MaxPrice = n
		}
	}
	if v := c.Query("is_premium"); v != "" {
		b := v == "true"
		params.IsPremium = &b
	}
	if v := c.Query("is_sale"); v != "" {
		b := v == "true"
		params.IsSale = &b
	}

	result, err := h.uc.Search(params)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusOK, result)
}
