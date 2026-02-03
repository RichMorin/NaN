#!/usr/bin/env python3
import argparse
import math
import re
from pathlib import Path


def get_node_xy(svg_text: str, title: str):
    m = re.search(
        rf'<g id="node\d+" class="node">\s*<title>{re.escape(title)}</title>(.*?)</g>',
        svg_text,
        re.S,
    )
    if not m:
        raise SystemExit(f"Node {title} not found")
    block = m.group(1)
    m_x = re.search(r'<text[^>]* x="([-\d\.]+)"', block)
    if not m_x:
        raise SystemExit(f"No text x for {title}")
    x = float(m_x.group(1))
    m_path = re.search(r'<path[^>]* d="([^"]+)"', block)
    if not m_path:
        raise SystemExit(f"No path for {title}")
    d = m_path.group(1)
    ys = [float(v) for v in re.findall(r'[-\d\.]+,([-\d\.]+)', d)]
    if not ys:
        raise SystemExit(f"No ys for {title}")
    y_bottom = max(ys)
    return x, y_bottom


def main():
    ap = argparse.ArgumentParser(description="Patch PG1->SM1 edge in example.svg.")
    ap.add_argument(
        "--svg",
        default="/Users/rdm/NaN/docs/diagrams/svg/example.svg",
        help="Path to example.svg",
    )
    ap.add_argument("--depth", type=float, default=45.0, help="Curve depth below nodes")
    ap.add_argument("--c1", type=float, default=0.35, help="C1 x position (0..1)")
    ap.add_argument("--c2", type=float, default=0.65, help="C2 x position (0..1)")
    ap.add_argument("--height", type=float, default=None, help="Set SVG height in pt")
    ap.add_argument("--viewbox-height", type=float, default=None, help="Set SVG viewBox height")
    args = ap.parse_args()

    svg_path = Path(args.svg)
    text = svg_path.read_text()

    if args.height is not None:
        text = re.sub(r'height="[\d\.]+pt"', f'height="{args.height:.0f}pt"', text)
    if args.viewbox_height is not None:
        text = re.sub(
            r'viewBox="0\.00 0\.00 ([\d\.]+) ([\d\.]+)"',
            lambda m: f'viewBox="0.00 0.00 {m.group(1)} {args.viewbox_height:.2f}"',
            text,
        )

    x0, y0 = get_node_xy(text, "PG1")
    x1, y1 = get_node_xy(text, "SM1")

    base_y = max(y0, y1)
    ctrl_y = base_y + args.depth

    c1x = x0 + (x1 - x0) * args.c1
    c2x = x0 + (x1 - x0) * args.c2

    path_d = (
        f"M {x0:.2f},{y0:.2f} C {c1x:.2f},{ctrl_y:.2f} "
        f"{c2x:.2f},{ctrl_y:.2f} {x1:.2f},{y1:.2f}"
    )

    vx = x1 - c2x
    vy = y1 - ctrl_y
    length = math.hypot(vx, vy) or 1.0
    ux, uy = vx / length, vy / length
    arrow_len = 10.0
    arrow_w = 6.0
    bx = x1 - ux * arrow_len
    by = y1 - uy * arrow_len
    px, py = -uy, ux
    p1x, p1y = bx + px * (arrow_w / 2), by + py * (arrow_w / 2)
    p2x, p2y = bx - px * (arrow_w / 2), by - py * (arrow_w / 2)
    poly_points = f"{x1:.2f},{y1:.2f} {p1x:.2f},{p1y:.2f} {p2x:.2f},{p2y:.2f}"

    def repl_edge(match):
        block = match.group(0)
        block = re.sub(
            r'<path[^>]*d="[^"]+"[^>]*/>',
            f'<path fill="none" stroke="#000000" stroke-linecap="round" '
            f'stroke-linejoin="round" d="{path_d}"/>',
            block,
            count=1,
        )
        if re.search(r"<polygon[^>]*>", block):
            block = re.sub(
                r"<polygon[^>]*>",
                f'<polygon fill="#000000" stroke="#000000" points="{poly_points}"/>',
                block,
                count=1,
            )
        else:
            block = block.rstrip() + (
                f'\n<polygon fill="#000000" stroke="#000000" points="{poly_points}"/>\n'
            )
        return block

    pattern = r'<g id="edge\d+" class="edge">\s*<title>PG1.*?</g>'
    text2, n = re.subn(pattern, repl_edge, text, flags=re.S)
    if n != 1:
        raise SystemExit(f"Edge block not found or multiple ({n})")

    svg_path.write_text(text2)
    print(f"Patched {svg_path}")


if __name__ == "__main__":
    main()
