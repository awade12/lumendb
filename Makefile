.PHONY: clean build publish publish-test version-major version-minor version-patch

PYTHON := python3
PYPIRC := $(PWD)/.pypirc
VERSION_FILE := version.txt
PYPROJECT_FILE := pyproject.toml

# Get current version from version.txt
CURRENT_VERSION := $(shell cat $(VERSION_FILE))
MAJOR := $(shell echo $(CURRENT_VERSION) | cut -d. -f1)
MINOR := $(shell echo $(CURRENT_VERSION) | cut -d. -f2)
PATCH := $(shell echo $(CURRENT_VERSION) | cut -d. -f3)

clean:
	rm -rf dist/ build/ *.egg-info/
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

build: clean
	$(PYTHON) -m pip install --upgrade build
	$(PYTHON) -m build

check-version:
	@if curl -s https://pypi.org/pypi/lumendb/$(NEW_VERSION)/json | grep '"message": "Not Found"' > /dev/null; then \
		echo "Version $(NEW_VERSION) is available for publishing."; \
	else \
		echo "Version $(NEW_VERSION) already exists on PyPI"; \
		exit 1; \
	fi

publish-test: build
	$(PYTHON) -m pip install --upgrade twine
	$(PYTHON) -m twine upload --config-file $(PYPIRC) --repository testpypi dist/*

publish: build
	$(PYTHON) -m pip install --upgrade twine
	$(PYTHON) -m twine upload --config-file $(PYPIRC) --repository pypi dist/*

version:
	@echo "Current version: $(CURRENT_VERSION)"

set-version:
	@if [ -z "$(NEW_VERSION)" ]; then \
		echo "NEW_VERSION is not set"; \
		exit 1; \
	fi
	@echo "Setting version to $(NEW_VERSION)"
	@echo "$(NEW_VERSION)" > $(VERSION_FILE)
	@sed -i.bak "s/^version = \".*\"/version = \"$(NEW_VERSION)\"/" $(PYPROJECT_FILE) && rm $(PYPROJECT_FILE).bak
	@echo "Version updated to $(NEW_VERSION) in all files"

calculate-major-version:
	@NEW_VERSION="$$(($$(echo $(MAJOR)) + 1)).0.0"; \
	echo $$NEW_VERSION > $(VERSION_FILE); \
	sed -i.bak "s/^version = \".*\"/version = \"$$NEW_VERSION\"/" $(PYPROJECT_FILE) && rm $(PYPROJECT_FILE).bak

calculate-minor-version:
	@NEW_VERSION="$(MAJOR).$$(($$(echo $(MINOR)) + 1)).0"; \
	echo $$NEW_VERSION > $(VERSION_FILE); \
	sed -i.bak "s/^version = \".*\"/version = \"$$NEW_VERSION\"/" $(PYPROJECT_FILE) && rm $(PYPROJECT_FILE).bak

calculate-patch-version:
	@NEW_VERSION="$(MAJOR).$(MINOR).$$(($$(echo $(PATCH)) + 1))"; \
	echo $$NEW_VERSION > $(VERSION_FILE); \
	sed -i.bak "s/^version = \".*\"/version = \"$$NEW_VERSION\"/" $(PYPROJECT_FILE) && rm $(PYPROJECT_FILE).bak

version-major: calculate-major-version
	@$(eval NEW_VERSION := $(shell cat $(VERSION_FILE)))
	@$(MAKE) check-version NEW_VERSION=$(NEW_VERSION)
	@echo "Bumping major version to $(NEW_VERSION)..."
	@$(MAKE) set-version NEW_VERSION=$(NEW_VERSION)

version-minor: calculate-minor-version
	@$(eval NEW_VERSION := $(shell cat $(VERSION_FILE)))
	@$(MAKE) check-version NEW_VERSION=$(NEW_VERSION)
	@echo "Bumping minor version to $(NEW_VERSION)..."
	@$(MAKE) set-version NEW_VERSION=$(NEW_VERSION)

version-patch: calculate-patch-version
	@$(eval NEW_VERSION := $(shell cat $(VERSION_FILE)))
	@$(MAKE) check-version NEW_VERSION=$(NEW_VERSION)
	@echo "Bumping patch version to $(NEW_VERSION)..."
	@$(MAKE) set-version NEW_VERSION=$(NEW_VERSION)

# Combined commands for version bump and publish
release-major: version-major build publish
	git add $(VERSION_FILE) $(PYPROJECT_FILE)
	git commit -m "Bump major version to $(CURRENT_VERSION)"
	git tag v$(CURRENT_VERSION)
	git push && git push --tags

release-minor: version-minor build publish
	git add $(VERSION_FILE) $(PYPROJECT_FILE)
	git commit -m "Bump minor version to $(CURRENT_VERSION)"
	git tag v$(CURRENT_VERSION)
	git push && git push --tags

release-patch: version-patch build publish
	git add $(VERSION_FILE) $(PYPROJECT_FILE)
	git commit -m "Bump patch version to $(CURRENT_VERSION)"
	git tag v$(CURRENT_VERSION)
	git push && git push --tags

install: clean
	$(PYTHON) -m pip install -e . 
