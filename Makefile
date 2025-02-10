SERVICE_NAME=vue-app
HOST_UID=$(shell id -u)
HOST_GID=$(shell id -g)

.PHONY: help
help: Makefile
	@echo "Lista de comandos disponibles para gestionar el contenedor del servicio $(SERVICE_NAME):"
	@echo ""
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-10s\033[0m %s\n", $$1, $$2}'

.PHONY: up
up: ## Inicia los contenedores
	docker-compose up

.PHONY: down
down: ## Detiene y elimina los recursos generados por 'up'
	docker-compose down

.PHONY: sh
sh: ## Accede al shell del contenedor de la aplicación
	docker-compose exec $(SERVICE_NAME) sh

.PHONY: build
build: ## Construye la imagen de Docker basada en el Dockerfile
	docker-compose build $(SERVICE_NAME)

.PHONY: add
add: ## Agrega paquetes con pnpm dentro del contenedor, e.g., make add vue-router@next axios
	@docker-compose run --rm $(SERVICE_NAME) pnpm add $(filter-out $@,$(MAKECMDGOALS))

# .PHONY: create
create_old: ## Crea un nuevo proyecto Vite con template vue-ts e instala eslint
	# docker-compose run --rm $(SERVICE_NAME) pnpm create vite . --template vue-ts && \
	# docker-compose run --rm $(SERVICE_NAME) sh -c "pnpm add -D eslint"
	
.PHONY: create
create:
	docker-compose run --rm $(SERVICE_NAME) sh -c "pnpm create vite . --template vue-ts && \
	printf \"import { defineConfig } from 'vite';\\n\\nexport default defineConfig({\\n  server: {\\n    port: 3000\\n  }\\n});\" > vite.config.ts && \
	pnpm add -D eslint && \
	chown -R $(HOST_UID):$(HOST_GID) ."

%:
	@:

.PHONY: default
default: help