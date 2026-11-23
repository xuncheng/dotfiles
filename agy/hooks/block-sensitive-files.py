#!/usr/bin/env python3
"""Antigravity PreToolUse hook blocking access to sensitive files and directories.

Native read_file permissions only support exact workspace-relative or absolute
paths, so this hook enforces recursive matching for .env*, certs/, secrets/,
private keys, and home-directory credentials across nested subprojects.
"""

import json
import os
import sys
from pathlib import Path

ENV_EXAMPLE_NAMES = {".env.example", ".env.sample", ".env.template"}
SENSITIVE_DIRS = {"certs", "secrets"}
SENSITIVE_FILENAMES = {".envrc", ".npmrc", ".netrc", ".git-credentials"}
SENSITIVE_EXTENSIONS = {".pem", ".key", ".p12", ".pfx"}

HOME_RELATIVE_DIRS = (
    (".tencent",),
    (".config", ".cloudbase"),
    (".ssh",),
    (".aws",),
    (".kube",),
    (".config", "gcloud"),
    (".config", "gh"),
)
HOME_RELATIVE_FILES = (
    (".docker", "config.json"),
    (".claude", ".credentials.json"),
)

PATH_ARG_KEYS = (
    "Path",
    "AbsolutePath",
    "TargetFile",
    "SearchPath",
    "path",
    "file_path",
)


def extract_target_path(payload: dict) -> str | None:
    tool_call = payload.get("toolCall")
    if not isinstance(tool_call, dict):
        return None
    args = tool_call.get("args")
    if not isinstance(args, dict):
        return None
    for key in PATH_ARG_KEYS:
        value = args.get(key)
        if isinstance(value, str) and value.strip():
            return value.strip()
    return None


def match_sensitive(path: Path, home: Path) -> str | None:
    parts_lower = [part.lower() for part in path.parts]
    name_lower = path.name.lower()

    for segment in parts_lower:
        if segment in SENSITIVE_DIRS:
            return f"sensitive directory '{segment}/'"

    if (name_lower == ".env" or name_lower.startswith(".env.")) and (
        name_lower not in ENV_EXAMPLE_NAMES
    ):
        return f"environment file '{path.name}'"

    if name_lower in SENSITIVE_FILENAMES:
        return f"credential file '{path.name}'"

    if name_lower == "id_rsa" or name_lower.startswith("id_rsa."):
        return f"SSH key file '{path.name}'"

    if path.suffix.lower() in SENSITIVE_EXTENSIONS:
        return f"certificate or key file '{path.name}'"

    try:
        rel = path.relative_to(home)
    except ValueError:
        return None

    rel_parts = [part.lower() for part in rel.parts]
    if not rel_parts:
        return None

    if len(rel_parts) == 1 and rel_parts[0].startswith(".tcbrc"):
        return f"CloudBase credential file '~/{rel.parts[0]}'"

    for prefix in HOME_RELATIVE_DIRS:
        if tuple(rel_parts[: len(prefix)]) == prefix:
            return f"home credential directory '~/{'/'.join(prefix)}/'"

    for exact in HOME_RELATIVE_FILES:
        if tuple(rel_parts) == exact:
            return f"home credential file '~/{'/'.join(exact)}'"

    return None


def check_path(raw_path: str, cwd: str | None) -> str | None:
    home = Path.home()
    expanded = Path(os.path.expanduser(raw_path))
    if not expanded.is_absolute() and cwd:
        expanded = Path(cwd) / expanded

    lexical = Path(os.path.normpath(str(expanded)))
    candidates = [lexical]

    # Resolve symlinks so links pointing into sensitive targets cannot bypass checks.
    real = Path(os.path.realpath(str(lexical)))
    if real != lexical:
        candidates.append(real)

    home_real = Path(os.path.realpath(str(home)))
    for candidate in candidates:
        for h in (home, home_real):
            reason = match_sensitive(candidate, h)
            if reason:
                return reason
    return None


def main() -> int:
    raw = sys.stdin.read()
    if not raw.strip():
        print(json.dumps({"decision": "allow"}))
        return 0

    try:
        payload = json.loads(raw)
    except json.JSONDecodeError:
        print(
            json.dumps(
                {
                    "decision": "deny",
                    "reason": "Failed to parse hook input; denying access defensively.",
                }
            )
        )
        return 0

    target = extract_target_path(payload)
    if not target:
        print(json.dumps({"decision": "allow"}))
        return 0

    cwd = payload.get("cwd") if isinstance(payload.get("cwd"), str) else None
    reason = check_path(target, cwd)
    if reason:
        print(
            json.dumps(
                {
                    "decision": "deny",
                    "reason": f"Blocked access to {reason}.",
                }
            )
        )
        return 0

    print(json.dumps({"decision": "allow"}))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
