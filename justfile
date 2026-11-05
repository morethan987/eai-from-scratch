# EAI-336 (Embodied AI from Scratch) Command Runner
# Based on [just](https://github.com/casey/just)

# run `just` cmd only
default:
    @just --list --unsorted

# setup env
setup:
    @echo "📦 Syncing Python dependencies with uv..."
    uv sync
    @echo "🪝 Installing prek Git Hooks (pre-commit & pre-push)..."
    uv run prek install
    @echo "✨ Environment setup complete! Run 'just test' directly to get started."

# update uv lock file
lock:
    uv lock --upgrade

# Run tests: supports passing native pytest arguments (e.g. `just test` or `just test -k rotation`)
test *args:
    uv run pytest {{args}}

# Fast parallel testing: uses pytest-xdist to utilize all CPU cores and finish in milliseconds
test-fast:
    uv run pytest -n auto

# Conveniently test a single module: e.g. `just test-m 1` tests only Module 1 control algorithms
test-m module:
    uv run pytest tests/test_module{{module}}_*.py

# Auto-format all code (Ruff)
fmt:
    uv run ruff check --fix src tests scripts
    uv run ruff format src tests scripts

# Run Astral's new static type checker (ty)
typecheck:
    uv run ty check src

# Run the full set of local pre-commit checks (including large files, conflict markers, and formatting)
check:
    uv run prek run --all-files

# Compile and generate the handout PDF
doc:
    @echo "Compiling Typst handout..."
    typst compile handout/handout.typ handout/handout.pdf
    @echo "Handout generated successfully: handout/handout.pdf"

# Enable Typst live hot-reload preview (use while writing handouts)
doc-watch:
    typst watch handout/handout.typ handout/handout.pdf

# One-click convert the current main branch and push to the student blank branch
release-student:
    @echo "About to clear implementation code and generate the student blank branch..."
    uv run scripts/release_student.py
    @echo "🚀 Pushing to remote student branch..."
    git push origin student --force
