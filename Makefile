COVERAGE=1
BUILD_EXAMPLES=1

# Debug or Release Configuration depending on whether coverage is enabled
ifeq ($(COVERAGE),1)
	BUILD_TYPE ?= Debug
else
	BUILD_TYPE ?= Release
endif

# Build Directory
BUILD_DIR ?= build

# Run all by building, running tests, and executable
all: build

# Build using Ninja with configuration type
.PHONY: build
build:
	cmake -GNinja -B $(BUILD_DIR)/$(BUILD_TYPE) -DCMAKE_BUILD_TYPE=$(BUILD_TYPE) -DBUILD_TESTING=$(COVERAGE) -DBUILD_EXAMPLES=$(BUILD_EXAMPLES)
	cmake --build $(BUILD_DIR)/$(BUILD_TYPE) --config $(BUILD_TYPE)

# Run tests, depends on build
.PHONY: test
test: build
	cmake --build $(BUILD_DIR)/$(BUILD_TYPE)  --target test

# Run execuatable, depends on build
.PHONY: run
run: build
	./$(BUILD_DIR)/$(BUILD_TYPE)/examples/main/mainExampleProject

# Run code coverage 
.PHONY: coverage
coverage: build
	cmake --build $(BUILD_DIR)/$(BUILD_TYPE) --target coverage

# Clean build directory
clean clear:
	rm -rf $(BUILD_DIR)