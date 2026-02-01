.PHONY: render render-all watch gen build watch-build serve

# Usage: make render FILE=docs/diagrams/dot/example.dot
render:
	@if [ -z "$(FILE)" ]; then \
		echo "Usage: make render FILE=docs/diagrams/dot/your-file.dot"; \
		exit 1; \
	fi
	@./scripts/render-dot.sh "$(FILE)"

# Renders all .dot files under docs/diagrams/dot
render-all:
	@./scripts/watch-dot.sh --once

# Watches and re-renders on change
watch:
	@./scripts/watch-dot.sh

# Generate _site/gen/docs (macros + diagrams)
gen:
	@./scripts/build-gen.sh

# Build site using generated docs
build: gen
	@bundle exec jekyll build -s _site/gen/docs -d _site/site

# Watch docs and rebuild generated site on changes
watch-build:
	@./scripts/watch-build.sh 2>&1 | tee -a logs/watch-build.log

# Serve generated site (static)
serve:
	@bundle exec jekyll serve -s _site/gen/docs -d _site/site --watch --livereload --port 4000 2>&1 | tee -a logs/serve.log
