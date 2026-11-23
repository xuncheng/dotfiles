#!/usr/bin/env python3
"""Merge managed Antigravity CLI settings into the local settings file.

Antigravity CLI atomically rewrites settings.json on startup and stores
machine-local state such as trustedWorkspaces and model there, so merging
managed keys avoids broken symlinks and dirty worktrees.
"""

import json
import os
import sys
import tempfile
from pathlib import Path


def load_json_object(path: Path) -> dict:
    raw = path.read_text(encoding="utf-8")
    if not raw.strip():
        return {}
    data = json.loads(raw)
    if not isinstance(data, dict):
        raise ValueError(f"Expected a JSON object in {path}")
    return data


def merge_settings(source_path: Path, target_path: Path) -> bool:
    managed = load_json_object(source_path)
    existing = load_json_object(target_path) if target_path.exists() else {}

    merged = dict(existing)
    merged.update(managed)

    rendered = json.dumps(merged, indent=2) + "\n"
    if (
        target_path.exists()
        and not target_path.is_symlink()
        and target_path.read_text(encoding="utf-8") == rendered
    ):
        os.chmod(target_path, 0o600)
        return False

    target_path.parent.mkdir(parents=True, exist_ok=True)
    fd, tmp_name = tempfile.mkstemp(
        dir=target_path.parent, prefix=".settings.", suffix=".tmp"
    )
    tmp_path = Path(tmp_name)
    try:
        with os.fdopen(fd, "w", encoding="utf-8") as handle:
            handle.write(rendered)
        os.chmod(tmp_path, 0o600)
        os.replace(tmp_path, target_path)
    except Exception:
        tmp_path.unlink(missing_ok=True)
        raise

    return True


def main() -> int:
    if len(sys.argv) != 3:
        print(
            f"Usage: {sys.argv[0]} <managed-settings.json> <target-settings.json>",
            file=sys.stderr,
        )
        return 2

    source_path = Path(os.path.expanduser(sys.argv[1]))
    target_path = Path(os.path.expanduser(sys.argv[2]))
    merge_settings(source_path, target_path)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
