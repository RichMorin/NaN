---
layout: default
title: "Dotty explorations"
---

# Dotty explorations

The diagrams on this page were developed almost entirely
by [Codex CLI](https://chatgpt.com/features/codex), based on my input.
The page uses a variety of tooling,
including assorted [Graphviz]($WP/Graphviz) tools,
[Markdown]($WP/Markdown), and [SVG]($WP/SVG).
Having created (much simpler) pages by hand,
I am all too well aware of how much work this project would have been.
Color me impressed...

## Diagrams

This diagram is based on some postings I made
on the [Thousand Brains Project](https://thousandbrains.org/) (TBP)
[forum](https://thousandbrains.discourse.group/).
It shows a possible architecture for image recognition,
coupling an [LLM]($WP/LLM)-based "Image Tagger" to some
[Thousand Brains Theory](https://www.numenta.com/blog/2019/01/16/the-thousand-brains-theory-of-intelligence) (TBT)-based modules.

So, for example, the Image Tagger might tell the Attention Tracker
that it recognized a coffee cup at a particular point in the image;
the Patch Grabber would then grab a patch of pixels at that location
and send it to the Sensor Module to be distributed to Monty's Learning Modules.

![Top diagram]({{ "/diagrams/svg/top.svg" | relative_url }})

This diagram extends the Patch Grabber data flow.
The idea is that the Temporal Manager would handle when the image was seen
and the Transform Manager would perform desired transformations:

![Bottom diagram]({{ "/diagrams/svg/bottom.svg" | relative_url }})

Putting it all together, here is the full diagram:

![Full diagram]({{ "/diagrams/svg/example.svg" | relative_url }})

## Discussion

Graphviz is a very capable diagram generation suite,
but its syntax is a bit arcane and crafting complex diagrams can be tricky.
So, I used Codex CLI to generate the diagram description files in SVG.
And, because the result wasn't displaying well,
I had Codex CLI generate an editing script to fix things up:

> `patch-example-svg.py` post‑processes the generated `example.svg` diagram to
  correct a specific curved edge (Patch Grabber → Sensor Module) that Graphviz
  can’t consistently render via DOT alone. It adjusts the spline curvature,
  ensures the arrowhead is visible and correctly oriented, and expands the SVG
  viewBox/height to prevent clipping. This keeps the final diagram visually
  consistent without hand‑editing the SVG each time.
  
