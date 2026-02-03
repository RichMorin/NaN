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

## Prior history

The NaN (Notes and Notions) project previously existed as an independent GitHub
repository and was published via GitHub Pages. During consolidation into the
AI_WB working base, the project’s working tree was relocated and re-initialized
locally to simplify tooling and reduce coupling.

The current repository represents a continuation of that project. GitHub
remotes and publication settings will be re-established explicitly rather than
inferred.

## Canonical locations

- GitHub repository: https://github.com/RichMorin/NaN
- Public site (GitHub Pages): https://richmorin.github.io/NaN/

These URLs declare the intended canonical locations for the NaN (Notes and
Notions) project. Repository wiring and publication mechanics are configured
explicitly and may evolve without changing project identity.
