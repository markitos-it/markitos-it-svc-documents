package grpc

import (
	"context"
	"log"

	"markitos-it-svc-documents/internal/application/services"
	"markitos-it-svc-documents/internal/domain/documents"
	pb "markitos-it-svc-documents/proto"

	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
	"google.golang.org/protobuf/types/known/timestamppb"
)

type DocumentServer struct {
	pb.UnimplementedDocumentServiceServer
	service *services.DocumentService
}

func NewDocumentServer(service *services.DocumentService) *DocumentServer {
	return &DocumentServer{
		service: service,
	}
}

func (s *DocumentServer) GetAllDocuments(ctx context.Context, req *pb.GetAllDocumentsRequest) (*pb.GetAllDocumentsResponse, error) {
	log.Println("GetAllDocuments called")

	docs, err := s.service.GetAllDocuments(ctx)
	if err != nil {
		log.Printf("Error getting all documents: %v", err)
		return nil, status.Errorf(codes.Internal, "failed to get documents: %v", err)
	}

	pbDocs := make([]*pb.Document, 0, len(docs))
	for _, doc := range docs {
		pbDocs = append(pbDocs, documentToProto(&doc))
	}

	return &pb.GetAllDocumentsResponse{
		Documents: pbDocs,
	}, nil
}

func (s *DocumentServer) GetDocumentById(ctx context.Context, req *pb.GetDocumentByIdRequest) (*pb.GetDocumentByIdResponse, error) {
	log.Printf("GetDocumentById called with id: %s", req.Id)

	doc, err := s.service.GetDocumentByID(ctx, req.Id)
	if err != nil {
		log.Printf("Error getting document by id %s: %v", req.Id, err)
		return nil, status.Errorf(codes.NotFound, "document not found: %v", err)
	}

	return &pb.GetDocumentByIdResponse{
		Document: documentToProto(doc),
	}, nil
}

func documentToProto(doc *documents.Document) *pb.Document {
	return &pb.Document{
		Id:          doc.ID,
		Title:       doc.Title,
		Description: doc.Description,
		Category:    doc.Category,
		Tags:        doc.Tags,
		UpdatedAt:   timestamppb.New(doc.UpdatedAt),
		ContentB64:  doc.ContentB64,
		CoverImage:  doc.CoverImage,
	}
}
