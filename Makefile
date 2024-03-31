# Size of the assets in bytes for the HTML5 version.
HTML5_PACKAGE_SIZE=20000000

# Listening port for the Docker container, when running the HTML5 version.
DOCKER_PORT=8080

# The default target when running 'make' is 'all', which is defined below.

.PHONY: all
all: build

##@ General

# The help target prints out all targets with their descriptions organized
# beneath their categories. The categories are represented by '##@' and the
# target descriptions by '##'. The awk command is responsible for reading the
# entire set of makefiles included in this invocation, looking for lines of the
# file as xyz: ## something, and then pretty-format the target and help. Then,
# if there's a line with ##@ something, that gets pretty-printed as a category.
# More info on the usage of ANSI control characters for terminal formatting:
# https://en.wikipedia.org/wiki/ANSI_escape_code#SGR_parameters
# More info on the awk command:
# http://linuxcommand.org/lc3_adv_awk.php

.PHONY: help
help: ## Display this help.
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
##

.PHONY: clean
clean: ## Clean all targets.
	@echo "Cleaning..."
	@rm -rf node_modules tmp build/*

.PHONY: check-html5-deps
check-html5-deps: ## Check all deps.
	@echo "Checking deps..."
	@npm outdated || true
	@(which npx > /dev/null) || (echo "npx is not installed. Please install it by running 'asdf install node'." && exit 1)
	@(which love > /dev/null) || (echo "love is not installed. Please install it by running 'asdf install love'." && exit 1)

.PHONY: install-html5-deps
install-html5-deps: check-html5-deps ## Install all targets.
	@echo "Installing..."
	@npm install

.PHONY: build
build: build-html5 ## Build all targets.

.PHONY: build-html5
build-html5: install-html5-deps ## Build the HTML5 target.
	@echo "Building HTML5 target..."
	@mkdir -p tmp/build 2>/dev/null || true
	@rm -rf ${PWD}/build/* ${PWD}/tmp/build/*
	@cp -r src *.lua tmp
	@npx love.js -m $(HTML5_PACKAGE_SIZE) -t Pong -c ${PWD}/tmp ${PWD}/tmp/build
	@cp -r ${PWD}/tmp/build/* ${PWD}/build
	@echo "Done. Build in 'build' folder. Run the HTML version with 'make docker-run'."

.PHONY: run
run:
	@echo "Running..."
	@love .

.PHONY: docker-build
docker-build:
	@docker build . -t pong

.PHONY: docker-run
docker-run:
	@echo "Running locally in Docker container (http://localhost:$(DOCKER_PORT))"
	@docker run -p $(DOCKER_PORT):80 pong