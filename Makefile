# Makefile
# Usage:
#   make sync
#   make format
#   make format-check
#   make lint
#   make lint-fix
#   make check
#   make test
#   make dev

PYTHON := uv run

.PHONY: sync format format-check lint lint-fix check test dev

sync:
	uv sync --dev

format:
	$(PYTHON) black .

format-check:
	$(PYTHON) black --check .

lint:
	$(PYTHON) ruff check .

lint-fix:
	$(PYTHON) ruff check . --fix

check: format-check lint

test:
	$(PYTHON) pytest -q

dev:
	$(PYTHON) uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
