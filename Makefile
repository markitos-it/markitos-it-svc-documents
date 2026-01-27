.DEFAULT_GOAL := help

.PHONY: help app-docker-postgres-start app-docker-postgres-stop proto-gen app-go-start app-docker-local-build app-docker-local-start app-docker-local-stop app-clean app-deploy-tag app-delete-tag

help:
	@echo "📋 Available commands (LOCAL DEVELOPMENT):"
	@echo ""
	@echo "  🚀 DESARROLLO:"
	@echo "  make app-start               	- Start app with go run (inicia PostgreSQL)"
	@echo "  make app-stop               	- Stop app with go run (para PostgreSQL)"
	@echo ""
	@echo "  🗄️  BASE DE DATOS:"
	@echo "  make app-docker-postgres-start - Start PostgreSQL only"
	@echo "  make app-docker-postgres-stop  - Stop PostgreSQL only"
	@echo ""
	@echo "  🛠️  UTILIDADES:"
	@echo "  make proto-gen                 - Generate protobuf code"
	@echo "  make app-clean                 - Remove artifacts and stop PostgreSQL"
	@echo ""
	@echo "  ☸️  KUBERNETES (deployment/):"
	@echo "  make app-deploy-tag <version>  - Create and push git tag (e.g., 1.2.3)"
	@echo "  make app-delete-tag <version>  - Delete git tag locally and remotely"
	@echo ""

app-docker-postgres-start:
	bash bin/app/docker-postgres-start.sh

app-docker-postgres-stop:
	bash bin/app/docker-postgres-stop.sh

proto-gen:
	bash bin/app/proto-gen.sh

app-start:
	bash bin/app/start.sh

app-stop:
	bash bin/app/stop.sh

app-clean:
	bash bin/app/clean.sh

app-deploy-tag:
	bash bin/app/deploy-tag.sh $(filter-out $@,$(MAKECMDGOALS))

app-delete-tag:
	bash bin/app/delete-tag.sh $(filter-out $@,$(MAKECMDGOALS))

%:
	@:
