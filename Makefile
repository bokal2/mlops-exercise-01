help:
	@echo 'Available commands:'
	@echo '  make install  - Installs all dependencies'
	@echo '  make shell    - Starts a shell with the virtualenv activated'
# 	@echo '  make run      - Runs a development server on localhost:8000'
	@echo '  make test     - Runs the tests'
	@echo '  make debug    - Starts pdb on the first test failure'
	@echo '  make cov      - Generates HTML coverage report: htmlcov/index.html'
	@echo '  make lint     - Runs the linters/static analysis'
	@echo '  make check    - Runs all checks'
	@echo '  make fix      - Fixes coding standards problems'

install:
	poetry install

shell:
	poetry shell

# run:
# 	poetry run uvicorn jobfeed_backend.main:app \
# 		--reload --no-access-log --log-config jobfeed_backend/logging.yaml

test:
	poetry run pytest

debug:
	poetry run pytest --no-cov -x --pdb

cov:
	poetry run pytest --cov-report html

lint:
	poetry run black --check .
	poetry run flake8
	poetry run mypy

check: lint
	poetry run pytest --no-cov -q

fix:
	poetry run black .
	poetry run isort .

scan:
	trivy fs --severity HIGH,CRITICAL --skip-dirs venv --format table .
