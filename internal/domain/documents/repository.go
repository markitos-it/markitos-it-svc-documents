package documents

import (
	"context"
)

// Repository define la interfaz para el repositorio de documentos
type Repository interface {
	// GetAll retorna todos los documentos
	GetAll(ctx context.Context) ([]Document, error)

	// GetByID retorna un documento por su ID
	GetByID(ctx context.Context, id string) (*Document, error)

	// Create crea un nuevo documento
	Create(ctx context.Context, doc *Document) error

	// Update actualiza un documento existente
	Update(ctx context.Context, doc *Document) error

	// Delete elimina un documento por su ID
	Delete(ctx context.Context, id string) error
}
