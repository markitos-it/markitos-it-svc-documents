# markitos-it-svc-documents

Microservicio gRPC para gestionar documentos con PostgreSQL.

## 🚀 Características

- **gRPC**: Protocolo eficiente para comunicación entre servicios
- **PostgreSQL**: Almacenamiento persistente de documentos
- **Clean Architecture**: Separación clara entre capas (domain, application, infrastructure)
- **Protobuf**: Definición de contratos con Protocol Buffers
- **Docker**: Contenedores para deployment consistente

## 📋 Requisitos

- Go 1.23+
- PostgreSQL 13+
- protoc (Protocol Buffers compiler)
- make

## 🏗️ Estructura del Proyecto

```
markitos-it-svc-documents/
├── cmd/app/                      # Punto de entrada
├── internal/
│   ├── domain/documents/         # Entidades y repositorios
│   ├── application/services/     # Lógica de negocio
│   └── infrastructure/
│       ├── grpc/                 # Servidor gRPC
│       └── persistence/postgres/ # Implementación PostgreSQL
├── proto/                        # Definiciones protobuf
├── bin/                          # Scripts de build/deploy
├── Dockerfile                    # Imagen Docker
└── Makefile                      # Comandos automatizados
```

## 🛠️ Configuración

### 1. Base de Datos PostgreSQL

**Opción A: Docker Compose (Recomendado)**

```bash
# Iniciar PostgreSQL
docker-compose up -d

# Verificar que está corriendo
docker-compose ps

# Ver logs
docker-compose logs -f postgres

# Detener
docker-compose down

# Detener y eliminar volumen (borra datos)
docker-compose down -v
```

**Opción B: PostgreSQL Local**

Crear la base de datos manualmente:

```sql
CREATE DATABASE documents_db;
CREATE USER postgres WITH PASSWORD 'postgres';
GRANT ALL PRIVILEGES ON DATABASE documents_db TO postgres;
```

**Opción C: pgAdmin (Interfaz web)**

```bash
# Iniciar con perfil tools
docker-compose --profile tools up -d

# Acceder a http://localhost:5050
# Email: admin@markitos.it
# Password: admin
```

### 2. Variables de Entorno

El servicio usa estas constantes (ver `cmd/app/main.go`):

```
grpcPort = "8888"
dbHost   = "localhost"
dbPort   = "5432"
dbUser   = "postgres"
dbPass   = "postgres"
dbName   = "documents_db"
```

## 📦 Comandos Make

```bash
# Generar código protobuf
make proto-gen

# Compilar binario
make app-go-build

# Ejecutar en desarrollo
make app-go-start

# Build Docker image
make app-docker-local-build

# Iniciar container
make app-docker-local-start

# Limpiar artifacts
make app-clean

# Deploy tag
make app-deploy-tag 1.0.0

# Eliminar tag
make app-delete-tag 1.0.0
```

## 🎯 Desarrollo

### Inicialización

```bash
# 1. Generar código protobuf
make proto-gen

# 2. Compilar
make app-go-build

# 3. Ejecutar (con PostgreSQL corriendo)
make app-go-start
```

### Testing con grpcurl

```bash
# Instalar grpcurl
brew install grpcurl

# Listar servicios
grpcurl -plaintext localhost:8888 list

# Listar métodos
grpcurl -plaintext localhost:8888 list documents.DocumentService

# Obtener todos los documentos
grpcurl -plaintext localhost:8888 documents.DocumentService/GetAllDocuments

# Obtener documento por ID
grpcurl -plaintext -d '{"id":"getting-started-keptn"}' \
  localhost:8888 documents.DocumentService/GetDocumentById
```

## 🐳 Docker

### Build local

```bash
make app-docker-local-build
```

### Ejecutar container

```bash
# Asegurarse que PostgreSQL está accesible
make app-docker-local-start
```

### Ver logs

```bash
docker logs -f markitos-svc-documents-local
```

## 🔌 API gRPC

### GetAllDocuments

Obtiene todos los documentos ordenados por fecha de actualización.

**Request:**
```protobuf
message GetAllDocumentsRequest {}
```

**Response:**
```protobuf
message GetAllDocumentsResponse {
  repeated Document documents = 1;
  int32 total = 2;
}
```

### GetDocumentById

Obtiene un documento específico por su ID.

**Request:**
```protobuf
message GetDocumentByIdRequest {
  string id = 1;
}
```

**Response:**
```protobuf
message GetDocumentByIdResponse {
  Document document = 1;
}
```

### Document Entity

```protobuf
message Document {
  string id = 1;
  string title = 2;
  string description = 3;
  string category = 4;
  repeated string tags = 5;
  google.protobuf.Timestamp updated_at = 6;
  string content_b64 = 7;         // Contenido en base64
  string cover_image = 8;         // URL de imagen
}
```

## 🗄️ Schema PostgreSQL

```sql
CREATE TABLE documents (
  id VARCHAR(255) PRIMARY KEY,
  title VARCHAR(500) NOT NULL,
  description TEXT,
  category VARCHAR(100),
  tags TEXT[],
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  content_b64 TEXT NOT NULL,
  cover_image VARCHAR(1000)
);

CREATE INDEX idx_documents_category ON documents(category);
CREATE INDEX idx_documents_updated_at ON documents(updated_at DESC);
```

## 📝 Seed Data

El servicio incluye 2 documentos de ejemplo:
- Getting Started with Keptn
- YouTube Data API v3 Integration

Se crean automáticamente al iniciar si la tabla está vacía.

## 🔍 Troubleshooting

### Error: "Failed to connect to database"

Verificar que PostgreSQL está corriendo:
```bash
psql -U postgres -d documents_db
```

### Error: "Failed to listen"

Puerto 8888 ya está en uso:
```bash
lsof -i :8888
kill -9 <PID>
```

### Regenerar protobuf

Si hay cambios en `proto/documents.proto`:
```bash
make proto-gen
```

## 📚 Stack Tecnológico

- **Go 1.23**: Lenguaje de programación
- **gRPC**: Framework RPC
- **Protocol Buffers**: Serialización
- **PostgreSQL**: Base de datos
- **lib/pq**: Driver PostgreSQL para Go
- **Docker**: Containerización

## 🤝 Integración con App Website

Este microservicio provee documentos via gRPC a `markitos-it-app-website`.

La entidad `Document` es la misma en ambos proyectos, facilitando la integración.

## 📄 Licencia

MIT
