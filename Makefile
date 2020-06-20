.PHONY: help
.DEFAULT_GOAL := help
help:
	@echo "---------------------------------------------------------------------------------------"
	@echo ""
	@echo "				CLI"
	@echo ""
	@echo "---------------------------------------------------------------------------------------"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"; printf "Usage: make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-25s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

##@ Development

build: ## Build
	mvn clean install && docker push docker.io/bhuwanupadhyay/expose-spring-boot-microservice-with-ingress-using-helm:0.0.1-SNAPSHOT

##@ Helm

start: ## Minikube start
	minikube start

deploy: ## Helm deploy
	./helm.sh --deploy

delete: ## Helm delete
	./helm.sh --delete
