# Paths
VCPKG_PATH ?= $(HOME)/vcpkg
TRIPLET    ?= arm64-osx
BIN_DIR    := bin
BUILD_DIR  := build
OUT_BIN    := $(BIN_DIR)/gocesiumtiler-darwin-arm64

# Go build flags
PKG_CONFIG_PATH := $(VCPKG_PATH)/installed/$(TRIPLET)/lib/pkgconfig
CGO_ENABLED := 1

GO_LDFLAGS := -X main.GitCommit=$(shell git rev-parse --short HEAD)

# Default target
all: $(OUT_BIN)

# Build the binary
$(OUT_BIN): | $(BIN_DIR)
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	CGO_ENABLED=$(CGO_ENABLED) \
	go build \
		-o $(OUT_BIN) \
		-ldflags "$(GO_LDFLAGS)" \
		./cmd/main.go

# Run tests
test:
	PKG_CONFIG_PATH=$(PKG_CONFIG_PATH) \
	CGO_ENABLED=$(CGO_ENABLED) \
	go test ./... -v

# Create bin/ dir if needed
$(BIN_DIR):
	mkdir -p $(BIN_DIR)

# Clean build artifacts
clean:
	rm -rf $(BIN_DIR) $(BUILD_DIR)

# Package release
package: all
	tar -czvf gocesiumtiler-darwin-arm64.tgz $(OUT_BIN) README.md LICENSE

.PHONY: all test clean package