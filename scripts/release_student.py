"""
Convert main branch to blank student branch
uv run scripts/release_student.py
uv run scripts/release_student.py --no-push
"""

import subprocess
import sys
from pathlib import Path


def run_cmd(cmd: list[str], hint: str = "") -> str:
    try:
        res = subprocess.run(cmd, capture_output=True, text=True, check=True)
        return res.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"[ERROR] Fail to run: {' '.join(cmd)}\n{e.stderr.strip()}")
        if hint:
            print(f"[INFO] {hint}")
        if e.stdout.strip():
            print(f"[STDOUT]\n{e.stdout.strip()}")
        if e.stderr.strip():
            print(f"[STDERR]\n{e.stderr.strip()}")
        if hint:
            print(f"[INFO] {hint}")
        sys.exit(1)


def has_remote(name: str = "origin") -> bool:
    try:
        remotes = subprocess.run(
            ["git", "remote"], capture_output=True, text=True, check=True
        ).stdout
        return name in remotes.split()
    except subprocess.CalledProcessError:
        return False


def main():
    do_push = "--no-push" not in sys.argv

    if run_cmd(["git", "branch", "--show-current"]) != "main":
        print("[ERROR] Run this script on the main branch!")
        sys.exit(1)

    if run_cmd(["git", "status", "--porcelain"]):
        print("[ERROR] Uncommitted changes on main. Please run git commit first!")
        sys.exit(1)

    run_cmd(["git", "checkout", "-B", "student"])

    # clear all files except for `__init__.py`
    src_dir = Path("src/eai336")
    for file in src_dir.rglob("*.py"):
        if file.name == "__init__.py":
            file.write_text("")
        else:
            file.unlink()

    run_cmd(["git", "add", "src/"])
    if run_cmd(["git", "status", "--porcelain"]):
        run_cmd(
            [
                "git",
                "commit",
                "-m",
                "chore: release student blank-slate template",
                "--no-verify",
            ]
        )
    else:
        print("[WARN] Nothing to commit — src/eai336 already blank on main?")

    run_cmd(["git", "checkout", "main"])

    if do_push:
        if not has_remote("origin"):
            print("[WARN] No 'origin' remote configured, skipping push.")
        else:
            print("[INFO] Pushing student branch to origin (--force) ...")
            run_cmd(
                ["git", "push", "origin", "student", "--force"],
                hint="Retry manually: git push origin student --force",
            )
            print("[OK] student branch pushed.")

    print("[DONE] Conversion complete. Local 'student' branch is now a clean slate.")
    if not do_push:
        print("[INFO] Run 'git push origin student --force' to push it.")


if __name__ == "__main__":
    main()
