.DEFAULT_GOAL := help

.PHONY: help app-docker-postgres-start app-docker-postgres-stop proto-gen app-go-start app-go-build app-docker-local-build app-docker-local-start app-docker-local-stop app-clean app-deploy-tag app-delete-tag

help:
	@echo "📋 Available commands:"
	@echo ""
	@echo "  make app-docker-postgres-start - Start PostgreSQL with Docker Compose"
	@echo "  make app-docker-postgres-stop  - Stop PostgreSQL"
	@echo "  make proto-gen                 - Generate protobuf code"
	@echo "  make app-go-start              - Start app with Go (development)"
	@echo "  make app-go-build              - Build Go binary to bin/app"
	@echo "  make app-docker-local-build    - Build Docker image with :local tag"
	@echo "  make app-docker-local-start    - Start Docker container locally"
	@echo "  make app-docker-local-stop     - Stop Docker containers (app + PostgreSQL)"
	@echo "  make app-clean                 - Remove bin/ and Docker :local image"
	@echo "  make app-deploy-tag <version>  - Create and push git tag (e.g., 1.2.3)"
	@echo "  make app-delete-tag <version>  - Delete git tag locally and remotely"
	@echo ""

app-docker-postgres-start:
	bash bin/app/docker-postgres-start.sh

app-docker-postgres-stop:
	bash bin/app/docker-postgres-stop.sh

proto-gen:
	bash bin/app/proto-gen.sh

app-go-start:
	bash bin/app/go-start.sh

app-go-build:
	bash bin/app/go-build.sh

app-docker-local-build:
	bash bin/app/docker-local-build.sh

app-docker-local-start:
	bash bin/app/docker-local-start.sh

app-docker-local-stop:
	bash bin/app/docker-local-stop.sh

app-clean:
	bash bin/app/clean.sh

app-deploy-tag:
	bash bin/app/deploy-tag.sh $(filter-out $@,$(MAKECMDGOALS))

app-delete-tag:
	bash bin/app/delete-tag.sh $(filter-out $@,$(MAKECMDGOALS))

%:
	@:
