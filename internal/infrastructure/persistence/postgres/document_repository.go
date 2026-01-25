package postgres

import (
	"context"
	"database/sql"
	"fmt"
	"time"

	"markitos-it-svc-documents/internal/domain/documents"

	"github.com/lib/pq"
)

type DocumentRepository struct {
	db *sql.DB
}

func NewDocumentRepository(db *sql.DB) *DocumentRepository {
	return &DocumentRepository{db: db}
}

func (r *DocumentRepository) InitSchema(ctx context.Context) error {
	schema := `
	CREATE TABLE IF NOT EXISTS documents (
		id VARCHAR(255) PRIMARY KEY,
		title VARCHAR(500) NOT NULL,
		description TEXT,
		category VARCHAR(100),
		tags TEXT[],
		updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
		content_b64 TEXT NOT NULL,
		cover_image VARCHAR(1000)
	);

	CREATE INDEX IF NOT EXISTS idx_documents_category ON documents(category);
	CREATE INDEX IF NOT EXISTS idx_documents_updated_at ON documents(updated_at DESC);
	`

	_, err := r.db.ExecContext(ctx, schema)
	if err != nil {
		return fmt.Errorf("failed to initialize schema: %w", err)
	}

	return nil
}

func (r *DocumentRepository) SeedData(ctx context.Context) error {
	// Check if data already exists
	var count int
	err := r.db.QueryRowContext(ctx, "SELECT COUNT(*) FROM documents").Scan(&count)
	if err != nil {
		return fmt.Errorf("failed to check existing data: %w", err)
	}

	if count > 0 {
		return nil // Data already seeded
	}

	docs := []documents.Document{
		{
			ID:          "getting-started-keptn",
			Title:       "Getting Started with Keptn",
			Description: "A comprehensive guide to get started with Keptn for automated deployment and operations",
			Category:    "DevOps",
			Tags:        []string{"keptn", "ci-cd", "automation", "kubernetes"},
			UpdatedAt:   time.Now(),
			ContentB64:  "IyBHZXR0aW5nIFN0YXJ0ZWQgd2l0aCBLZXB0bg==",
			CoverImage:  "https://images.unsplash.com/photo-1667372393119-3d4c48d07fc9",
		},
		{
			ID:          "youtube-api-integration",
			Title:       "YouTube Data API v3 Integration",
			Description: "Complete guide to integrate YouTube Data API with practical examples",
			Category:    "APIs",
			Tags:        []string{"youtube", "api", "rest", "video"},
			UpdatedAt:   time.Now(),
			ContentB64:  "IyBZb3VUdWJlIERhdGEgQVBJIHYzIEludGVncmF0aW9u",
			CoverImage:  "https://images.unsplash.com/photo-1611162616475-46b635cb6868",
		},
	}

	for _, doc := range docs {
		err := r.Create(ctx, &doc)
		if err != nil {
			return fmt.Errorf("failed to seed document %s: %w", doc.ID, err)
		}
	}

	return nil
}

func (r *DocumentRepository) GetAll(ctx context.Context) ([]documents.Document, error) {
	query := `
		SELECT id, title, description, category, tags, updated_at, content_b64, cover_image
		FROM documents
		ORDER BY updated_at DESC
	`

	rows, err := r.db.QueryContext(ctx, query)
	if err != nil {
		return nil, fmt.Errorf("failed to query documents: %w", err)
	}
	defer rows.Close()

	var docs []documents.Document
	for rows.Next() {
		var doc documents.Document
		var tags pq.StringArray

		err := rows.Scan(
			&doc.ID,
			&doc.Title,
			&doc.Description,
			&doc.Category,
			&tags,
			&doc.UpdatedAt,
			&doc.ContentB64,
			&doc.CoverImage,
		)
		if err != nil {
			return nil, fmt.Errorf("failed to scan document: %w", err)
		}

		doc.Tags = []string(tags)
		docs = append(docs, doc)
	}

	if err = rows.Err(); err != nil {
		return nil, fmt.Errorf("error iterating documents: %w", err)
	}

	return docs, nil
}

func (r *DocumentRepository) GetByID(ctx context.Context, id string) (*documents.Document, error) {
	query := `
		SELECT id, title, description, category, tags, updated_at, content_b64, cover_image
		FROM documents
		WHERE id = $1
	`

	var doc documents.Document
	var tags pq.StringArray

	err := r.db.QueryRowContext(ctx, query, id).Scan(
		&doc.ID,
		&doc.Title,
		&doc.Description,
		&doc.Category,
		&tags,
		&doc.UpdatedAt,
		&doc.ContentB64,
		&doc.CoverImage,
	)

	if err == sql.ErrNoRows {
		return nil, fmt.Errorf("document not found: %s", id)
	}
	if err != nil {
		return nil, fmt.Errorf("failed to query document: %w", err)
	}

	doc.Tags = []string(tags)
	return &doc, nil
}

func (r *DocumentRepository) Create(ctx context.Context, doc *documents.Document) error {
	query := `
		INSERT INTO documents (id, title, description, category, tags, updated_at, content_b64, cover_image)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
	`

	_, err := r.db.ExecContext(
		ctx,
		query,
		doc.ID,
		doc.Title,
		doc.Description,
		doc.Category,
		pq.Array(doc.Tags),
		doc.UpdatedAt,
		doc.ContentB64,
		doc.CoverImage,
	)

	if err != nil {
		return fmt.Errorf("failed to create document: %w", err)
	}

	return nil
}

func (r *DocumentRepository) Update(ctx context.Context, doc *documents.Document) error {
	query := `
		UPDATE documents
		SET title = $2, description = $3, category = $4, tags = $5, updated_at = $6, content_b64 = $7, cover_image = $8
		WHERE id = $1
	`

	result, err := r.db.ExecContext(
		ctx,
		query,
		doc.ID,
		doc.Title,
		doc.Description,
		doc.Category,
		pq.Array(doc.Tags),
		doc.UpdatedAt,
		doc.ContentB64,
		doc.CoverImage,
	)

	if err != nil {
		return fmt.Errorf("failed to update document: %w", err)
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return fmt.Errorf("failed to get rows affected: %w", err)
	}

	if rowsAffected == 0 {
		return fmt.Errorf("document not found: %s", doc.ID)
	}

	return nil
}

func (r *DocumentRepository) Delete(ctx context.Context, id string) error {
	query := `DELETE FROM documents WHERE id = $1`

	result, err := r.db.ExecContext(ctx, query, id)
	if err != nil {
		return fmt.Errorf("failed to delete document: %w", err)
	}

	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return fmt.Errorf("failed to get rows affected: %w", err)
	}

	if rowsAffected == 0 {
		return fmt.Errorf("document not found: %s", id)
	}

	return nil
}
