package main

import (
	"context"
	"database/sql"
	"fmt"
	"log"
	"net"
	"os"
	"os/signal"
	"syscall"

	"markitos-it-svc-documents/internal/application/services"
	grpcserver "markitos-it-svc-documents/internal/infrastructure/grpc"
	"markitos-it-svc-documents/internal/infrastructure/persistence/postgres"
	pb "markitos-it-svc-documents/proto"

	_ "github.com/lib/pq"
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
)

const (
	grpcPort = "8888"
	dbHost   = "localhost"
	dbPort   = "5432"
	dbUser   = "postgres"
	dbPass   = "postgres"
	dbName   = "documents_db"
)

func main() {
	log.Println("🚀 Starting Documents gRPC Service...")

	// Conectar a PostgreSQL
	dsn := fmt.Sprintf("host=%s port=%s user=%s password=%s dbname=%s sslmode=disable",
		dbHost, dbPort, dbUser, dbPass, dbName)

	db, err := sql.Open("postgres", dsn)
	if err != nil {
		log.Fatalf("❌ Failed to connect to database: %v", err)
	}
	defer db.Close()

	// Verificar conexión
	if err := db.Ping(); err != nil {
		log.Fatalf("❌ Failed to ping database: %v", err)
	}
	log.Println("✅ Connected to PostgreSQL")

	repo := postgres.NewDocumentRepository(db)
	ctx := context.Background()
	if err := repo.InitSchema(ctx); err != nil {
		log.Fatalf("❌ Failed to initialize schema: %v", err)
	}
	log.Println("✅ Database schema initialized")

	// Seed data (opcional)
	if err := repo.SeedData(ctx); err != nil {
		log.Printf("⚠️  Failed to seed data: %v", err)
	}

	// Inicializar servicio
	docService := services.NewDocumentService(repo)

	// Crear servidor gRPC
	lis, err := net.Listen("tcp", fmt.Sprintf(":%s", grpcPort))
	if err != nil {
		log.Fatalf("❌ Failed to listen: %v", err)
	}

	grpcServer := grpc.NewServer()
	pb.RegisterDocumentServiceServer(grpcServer, grpcserver.NewDocumentServer(docService))

	reflection.Register(grpcServer)

	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, os.Interrupt, syscall.SIGTERM)

	go func() {
		log.Printf("🎯 gRPC server listening on :%s", grpcPort)
		if err := grpcServer.Serve(lis); err != nil {
			log.Fatalf("❌ Failed to serve: %v", err)
		}
	}()

	<-sigChan
	log.Println("\n🛑 Shutting down gracefully...")
	grpcServer.GracefulStop()
	log.Println("👋 Service stopped")
}
