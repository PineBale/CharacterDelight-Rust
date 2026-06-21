CARGO          ?= cargo
PROFILE        ?= release
FEATURES       ?= --all-features

CLIPPY_PROFILE ?= $(PROFILE)
TEST_PROFILE   ?= $(PROFILE)

CLIPPY_FLAGS    = $(FEATURES) --all-targets -- -D warnings
TARPAULIN_FLAGS = --run-types AllTargets --out lcov --out stdout --skip-clean --target-dir target/tarpaulin

.PHONY: all build test lint lint-fix fmt fmt-check clean ci coverage

all: fmt-check lint test build

build:
	$(CARGO) build --profile $(PROFILE) $(FEATURES)

test:
	$(CARGO) test --profile $(TEST_PROFILE) $(FEATURES)

coverage:
	$(CARGO) tarpaulin --profile $(TEST_PROFILE) $(FEATURES) $(TARPAULIN_FLAGS)

lint:
	$(CARGO) clippy --profile $(CLIPPY_PROFILE) $(CLIPPY_FLAGS)

lint-fix:
	$(CARGO) clippy --profile $(CLIPPY_PROFILE) $(FEATURES) --fix --allow-dirty --allow-staged

fmt:
	$(CARGO) fmt

fmt-check:
	$(CARGO) fmt -- --check

clean:
	$(CARGO) clean

ci: fmt-check lint coverage build
