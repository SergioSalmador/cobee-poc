APP_NAME ?= go-webapp-sample
IMAGE ?= $(APP_NAME):alpine
CONTAINER ?= $(APP_NAME)
PORT ?= 8080
WEB_APP_ENV ?= develop
GO_BIN ?= $(shell command -v go 2>/dev/null)

.PHONY: check-docker build deploy health logs stop clean restart deploy-local stop-local logs-local

check-docker:
	@docker info >/dev/null 2>&1 || (echo "Docker daemon is not running or not reachable"; exit 1)

build:
	docker build -t $(IMAGE) .

deploy: check-docker build
	- docker rm -f $(CONTAINER) >/dev/null 2>&1
	docker run -d \
		--name $(CONTAINER) \
		-p $(PORT):8080 \
		-e WEB_APP_ENV=$(WEB_APP_ENV) \
		$(IMAGE)
	$(MAKE) health

health:
	@echo "Checking health endpoint on http://localhost:$(PORT)/api/health ..."
	@for i in 1 2 3 4 5 6 7 8 9 10; do \
		if curl -fsS "http://localhost:$(PORT)/api/health" | grep -qi "healthy"; then \
			echo "App is healthy"; \
			exit 0; \
		fi; \
		sleep 1; \
	done; \
	echo "Health check failed"; \
	exit 1

logs:
	docker logs --tail=100 $(CONTAINER)

stop:
	- docker rm -f $(CONTAINER)

clean: stop
	- docker rmi $(IMAGE)

restart: stop deploy

deploy-local:
	- rm -f .app.pid
	@if [ -z "$(GO_BIN)" ]; then echo "go binary not found"; exit 1; fi
	WEB_APP_ENV=$(WEB_APP_ENV) nohup $(GO_BIN) run main.go > .app.log 2>&1 & echo $$! > .app.pid
	$(MAKE) health

logs-local:
	@tail -n 100 .app.log

stop-local:
	@if [ -f .app.pid ]; then \
		kill "$$(cat .app.pid)" >/dev/null 2>&1 || true; \
		rm -f .app.pid; \
	fi
