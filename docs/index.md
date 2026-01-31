---
layout: default
title: "Notes and Notions"
---

# Notes and Notions

Welcome to **NaN**.

## Diagrams

- DOT sources live in `docs/diagrams/dot/`
- Generated SVGs are in `docs/diagrams/svg/`

When you add a `.dot` file, the GitHub Action renders it to SVG at build time.
You can then reference it like this:

```
![Example diagram](./diagrams/svg/example.svg)
```

### Example diagram

![Example diagram](./diagrams/svg/example.svg)

### Diagrams workflow

- Add DOT files under `docs/diagrams/dot/`
- Push to `main`
- GitHub Actions renders SVGs to `docs/diagrams/svg/`
- Reference SVGs in Markdown with relative links
