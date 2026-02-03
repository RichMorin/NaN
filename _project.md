# NaN project integration

## Project type

Static site project using Jekyll, with DOT diagrams rendered via Graphviz and a small post-processing step for SVG adjustments.

## Content root

Primary source content lives under content/docs/.

## Canonical build commands

From the project root:

- make gen
- make build
- make serve

## Compatibility assumptions

This setup uses relative symlinks (build/_site → ../_site and build/docs →
../content/docs) to satisfy tooling expectations about paths. The symlinks make
the build layout position-independent while keeping the content root unchanged.

## Generated artifacts

- Generated sources: _site/gen/docs/
- Built site output: _site/site/
- Rendered SVGs: _site/gen/docs/diagrams/svg/
