package services

import (
	"context"

	"markitos-it-svc-documents/internal/domain/documents"
)

type DocumentService struct {
	repo documents.Repository
}

func NewDocumentService(repo documents.Repository) *DocumentService {
	return &DocumentService{
		repo: repo,
	}
}

func (s *DocumentService) GetAllDocuments(ctx context.Context) ([]documents.Document, error) {
	return s.repo.GetAll(ctx)
}

func (s *DocumentService) GetDocumentByID(ctx context.Context, id string) (*documents.Document, error) {
	return s.repo.GetByID(ctx, id)
}

func (s *DocumentService) CreateDocument(ctx context.Context, doc *documents.Document) error {
	return s.repo.Create(ctx, doc)
}

func (s *DocumentService) UpdateDocument(ctx context.Context, doc *documents.Document) error {
	return s.repo.Update(ctx, doc)
}

func (s *DocumentService) DeleteDocument(ctx context.Context, id string) error {
	return s.repo.Delete(ctx, id)
}
