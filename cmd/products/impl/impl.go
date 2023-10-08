// ----------------------------------------------------------------------------
// Copyright (c) Ben Coleman, 2020
// Licensed under the MIT License.
//
// SQLite implementation of the ProductService
// ----------------------------------------------------------------------------

package impl

import (
	"database/sql"
	"fmt"
	"log"
	"os"

	"github.com/azure-samples/dapr-store/cmd/products/spec"
)

// ProductService is a Dapr based implementation of ProductService interface
type ProductService struct {
	*sql.DB
	serviceName string
}

// NewService creates a new ProductService
func NewService(serviceName string, dbFilePath string) *ProductService {
	_, err := os.Stat(dbFilePath)
	if os.IsNotExist(err) {
		log.Fatalf("### Failed to locate database %s %+v\n", dbFilePath, err)
	}

	// Note this will create the file if it doesn't exist, so we do the above check first
	db, err := sql.Open("sqlite3", fmt.Sprintf("file:%s", dbFilePath))
	if err != nil {
		log.Fatalf("### Error when opening database %s %+v\n", dbFilePath, err)
		return nil
	}

	log.Printf("### Database %s opened OK\n", dbFilePath)

	return &ProductService{
		db,
		serviceName,
	}
}

// QueryProducts is a simple SQL WHERE query on a single column
func (s ProductService) QueryProducts(column, term string) ([]spec.Product, error) {
	rows, err := s.Query("SELECT * FROM products WHERE "+column+" = ?", term)
	if err != nil {
		return nil, err
	}

	return s.processRows(rows)
}

// AllProducts returns all products from the DB, yeah this is pretty dumb
func (s ProductService) AllProducts() ([]spec.Product, error) {
	rows, err := s.Query("SELECT * FROM products")
	if err != nil {
		return nil, err
	}

	return s.processRows(rows)
}

// SearchProducts is a text search in name or  product description
func (s ProductService) SearchProducts(query string) ([]spec.Product, error) {
	rows, err := s.Query("SELECT * FROM products WHERE (description LIKE ? OR name LIKE ?)", "%"+query+"%", "%"+query+"%")
	if err != nil {
		return nil, err
	}

	return s.processRows(rows)
}

// Helper function to take a bunch of rows and return as a slice of Products
func (s ProductService) processRows(rows *sql.Rows) ([]spec.Product, error) {
	defer rows.Close()

	products := []spec.Product{}

	for rows.Next() {
		p := spec.Product{}
		err := rows.Scan(&p.ID, &p.Name, &p.Description, &p.Cost, &p.Image, &p.OnOffer)

		if err != nil {
			return nil, err
		}

		products = append(products, p)
	}

	return products, nil
}
