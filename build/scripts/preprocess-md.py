#!/usr/bin/env python3
import argparse
import re
from pathlib import Path


def load_macros(macros_path: Path):
    macros = {}
    if not macros_path.exists():
        return macros
    for line in macros_path.read_text().splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        if ":" not in line:
            continue
        key, val = line.split(":", 1)
        macros[key.strip()] = val.strip()
    return macros


def expand_macros(text: str, macros: dict[str, str]) -> str:
    # Expand $KEY/Path to macros[KEY] + Path
    def repl(match):
        key = match.group(1)
        rest = match.group(2)
        base = macros.get(key)
        if base is None:
            return match.group(0)
        return f"{base}{rest}"

    pattern = re.compile(r"\$([A-Z][A-Z0-9_]*)/([A-Za-z0-9_./-]+)")
    return pattern.sub(repl, text)


def main():
    ap = argparse.ArgumentParser(description="Expand $MACRO/Path in Markdown.")
    ap.add_argument("--macros", required=True, help="Path to md_macros.yml")
    ap.add_argument("--in", dest="src", required=True, help="Input file")
    ap.add_argument("--out", required=True, help="Output file")
    args = ap.parse_args()

    macros = load_macros(Path(args.macros))
    src_path = Path(args.src)
    out_path = Path(args.out)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    text = src_path.read_text()
    out_path.write_text(expand_macros(text, macros))


if __name__ == "__main__":
    main()
