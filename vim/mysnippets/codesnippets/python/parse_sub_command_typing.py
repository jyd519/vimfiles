from __future__ import annotations

import argparse
from collections.abc import Sequence
import sys


def main(argv: Sequence[str] | None = None) -> int:
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="command", required=True)

    subparsers.add_parser("debug", help="Show debug information.")

    hello_parser = subparsers.add_parser("hello", help="Say hello.")
    hello_parser.add_argument("name", help="Who to greet.")

    args = parser.parse_args(argv)

    if args.command == "debug":
        return debug()
    if args.command == "hello":
        return hello(name=args.name)

    raise NotImplementedError(
        f"Command {args.command} does not exist.",
    )


def debug() -> int:
    print(f"Python version {sys.version}")
    return 0


def hello(name: str) -> int:
    print(f"Hello {name}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())