#!/usr/bin/env python3
"""Fetch result artifacts from a remote experiment host."""

from __future__ import annotations

import argparse
from pathlib import Path


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("remote", help="Remote result location")
    parser.add_argument("--output", type=Path, default=Path("results"))
    args = parser.parse_args()
    print(f"Would fetch {args.remote} into {args.output}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
