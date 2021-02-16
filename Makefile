
NAMESPACE=""
REGISTRY="ghcr.io/ironpeakservices/iron-chart-hugo"
NAME="iron-chart-hugo"
STAGE="dev"
RELEASE="$(STAGE)"

K8S_DIR="kubernetes"
DOCKER_DIR=$(K8S_DIR)/docker
CHART_DIR=$(K8S_DIR)/helm

all: build up logs

clean:
	helm uninstall --namespace $(NAMESPACE) $(NAME) || true

build:
	@if [[ $(STAGE) == "prd" && $(RELEASE) == "prd" ]]; then echo "You must specify a release for production builds."; exit 1; fi;
	DOCKER_BUILDKIT=1 docker build -t $(REGISTRY)/$(NAME):$(RELEASE) -f $(DOCKER_DIR)/$(STAGE).Dockerfile .

up:
	kubectl create namespace $(NAMESPACE) || true
	helm upgrade \
		--debug --wait --install \
		--namespace $(NAMESPACE) \
		--values $(K8S_DIR)/$(STAGE).yaml \
		--set "devWorkingDirectory=$(shell pwd)" \
		--set "image.tag=$(RELEASE)" \
		--version "$(RELEASE)" \
		$(NAME) $(CHART_DIR)
	helm test --logs --namespace $(NAMESPACE) $(NAME)
	kubectl get pods --namespace $(NAMESPACE)

logs:
	kubectl logs --namespace $(NAMESPACE) -f -l app=$(NAME)

open:
	open "http://127.0.0.1:$$(kubectl get service -n $(NAMESPACE) | grep $(NAME) | grep -Eo '\d+\:\d+' | cut -d ':' -f 1)/"

getimages:
	@docker images --no-trunc "$(REGISTRY)/$(NAME)" | grep -v '^REPOSITORY' | awk '{print $$1":"$$2}'
