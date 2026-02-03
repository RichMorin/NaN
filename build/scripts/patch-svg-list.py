#!/usr/bin/env python3
import argparse
from pathlib import Path


def parse_simple_yaml(path: Path):
    data = {}
    current = None
    for raw in path.read_text().splitlines():
        line = raw.rstrip()
        if not line or line.lstrip().startswith("#"):
            continue
        if not line.startswith(" ") and line.endswith(":"):
            key = line[:-1].strip()
            data[key] = {}
            current = key
            continue
        if current is None:
            continue
        if ":" in line:
            k, v = line.strip().split(":", 1)
            data[current][k.strip()] = v.strip()
    return data


def to_float(val):
    try:
        return float(val)
    except Exception:
        return None


def main():
    ap = argparse.ArgumentParser(description="Apply svg patches from yaml list.")
    ap.add_argument("--patches", required=True, help="Path to svg_patches.yml")
    ap.add_argument("--svg-dir", required=True, help="Directory containing SVGs")
    ap.add_argument("--script", required=True, help="patch-example-svg.py path")
    args = ap.parse_args()

    patches_path = Path(args.patches)
    if not patches_path.exists():
        return
    patches = parse_simple_yaml(patches_path)
    svg_dir = Path(args.svg_dir)

    for name, cfg in patches.items():
        svg_path = svg_dir / name
        if not svg_path.exists():
            continue
        cmd = [
            "python3",
            args.script,
            "--svg",
            str(svg_path),
        ]
        if "depth" in cfg:
            cmd += ["--depth", cfg["depth"]]
        if "c1" in cfg:
            cmd += ["--c1", cfg["c1"]]
        if "c2" in cfg:
            cmd += ["--c2", cfg["c2"]]
        if "height" in cfg:
            cmd += ["--height", cfg["height"]]
        if "viewbox_height" in cfg:
            cmd += ["--viewbox-height", cfg["viewbox_height"]]
        import subprocess

        subprocess.run(cmd, check=True)


if __name__ == "__main__":
    main()
