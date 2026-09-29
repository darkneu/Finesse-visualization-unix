#!/usr/bin/env bash
# Finesse3 Optics Simulator — macOS / Linux Setup
# Run once to create the conda environment and install dependencies.
# Usage: bash setup.sh
#
# This is the POSIX port of setup.ps1. It mirrors the same robust logic:
#   * locate conda (PATH, then well-known install locations)
#   * detect an existing finesse_sim env via `conda env list`
#   * check for the required packages
#   * create / repair the env on request
# Everything is logged to a log file for diagnostics.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="${TMPDIR:-/tmp}/finesse_setup.log"

log() {
    printf '%s  %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*" | tee -a "$LOG_FILE"
}

echo "========================================"
echo " Finesse3 Optics Simulator — Setup"
echo "========================================"
echo ""

: > "$LOG_FILE" 2>/dev/null || true

# ---------------------------------------------------------------------------
# Locate conda: prefer `conda info --base`, then scan well-known locations.
# ---------------------------------------------------------------------------
CONDA_BASE=""
if command -v conda >/dev/null 2>&1; then
    CONDA_BASE="$(conda info --base 2>/dev/null | tr -d '"' | tr -d '\r')" || true
fi

if [ -z "$CONDA_BASE" ] || [ ! -d "$CONDA_BASE" ]; then
    for base in \
        "$HOME/miniconda3" \
        "$HOME/anaconda3" \
        "$HOME/miniforge3" \
        "$HOME/mambaforge" \
        "/opt/miniconda3" \
        "/opt/anaconda3" \
        "/opt/homebrew/Caskroom/miniconda/base" \
        "/usr/local/miniconda3" \
        "/usr/local/anaconda3"; do
        if [ -f "$base/etc/profile.d/conda.sh" ]; then
            CONDA_BASE="$base"
            break
        fi
    done
fi

if [ -z "$CONDA_BASE" ] || [ ! -f "$CONDA_BASE/etc/profile.d/conda.sh" ]; then
    echo "ERROR: conda not found. Install Miniconda first:"
    echo "  https://docs.conda.io/en/latest/miniconda.html"
    echo ""
    echo "  # Apple Silicon (M-series):"
    echo "  curl -L https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-arm64.sh -o ~/miniconda.sh"
    echo "  bash ~/miniconda.sh -b -p \$HOME/miniconda3"
    echo ""
    echo "  # Intel macOS:"
    echo "  curl -L https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -o ~/miniconda.sh"
    echo "  bash ~/miniconda.sh -b -p \$HOME/miniconda3"
    echo ""
    echo "  # Linux:"
    echo "  curl -L https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -o ~/miniconda.sh"
    echo "  bash ~/miniconda.sh -b -p \$HOME/miniconda3"
    exit 1
fi

log "conda base: $CONDA_BASE"
# shellcheck disable=SC1091
source "$CONDA_BASE/etc/profile.d/conda.sh"

# ---------------------------------------------------------------------------
# Detect an existing finesse_sim env (authoritative: `conda env list`).
# ---------------------------------------------------------------------------
ENV_PATH="$(conda env list 2>/dev/null | awk '$1=="finesse_sim" {print $NF}' | head -n1)"
ENV_EXISTS=0
if [ -n "$ENV_PATH" ] && [ -x "$ENV_PATH/bin/python" ]; then
    ENV_EXISTS=1
    log "finesse_sim env path: $ENV_PATH"
fi

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
create_env() {
    echo "Creating conda environment: finesse_sim ..."
    conda create -n finesse_sim python=3.12 -y

    echo ""
    echo "Installing dependencies (conda-forge: finesse, numpy, scipy, networkx) ..."
    conda install -y -n finesse_sim -c conda-forge finesse numpy scipy networkx || {
        echo ""
        echo "WARNING: Some scientific packages may not have installed correctly."
        echo "Try manually:"
        echo "  conda activate finesse_sim"
        echo "  conda install -c conda-forge finesse numpy scipy networkx"
    }

    echo ""
    echo "Installing Flask (pip) ..."
    conda run -n finesse_sim pip install flask || {
        echo "WARNING: Flask may not have installed correctly."
        echo "Try manually:"
        echo "  conda activate finesse_sim"
        echo "  pip install flask"
    }
}

remove_env() {
    echo "Removing existing finesse_sim environment ..."
    conda env remove -n finesse_sim -y
}

missing_packages() {
    local env_dir="$1"
    local site="$env_dir/lib/python3.12/site-packages"
    local missing=""
    for pkg in finesse numpy scipy networkx flask; do
        # Match either a package dir or a dist-info directory.
        if ! ls "$site" 2>/dev/null | grep -qi "^${pkg}\(\-\|\.\)"; then
            missing="$missing $pkg"
        fi
    done
    echo "$missing"
}

# ---------------------------------------------------------------------------
# Main flow
# ---------------------------------------------------------------------------
if [ "$ENV_EXISTS" -eq 1 ]; then
    echo "Found existing environment: finesse_sim"
    echo "Checking required packages ..."
    MISSING="$(missing_packages "$ENV_PATH")"

    if [ -z "$MISSING" ]; then
        echo "All required packages are already installed."
        read -r -p "The environment is already set up. Reinstall anyway? [y/N]: " REINSTALL
        if [[ "$REINSTALL" =~ ^[Yy]$ ]]; then
            remove_env
            create_env
        else
            echo "Nothing to do - the environment is ready. You can run run.sh now."
            exit 0
        fi
    else
        echo "The environment exists but is missing:$MISSING"
        read -r -p "Reinstall the environment to fix it? [y/N]: " REINSTALL
        if [[ "$REINSTALL" =~ ^[Yy]$ ]]; then
            remove_env
            create_env
        else
            echo "Aborted. No changes made."
            exit 0
        fi
    fi
else
    log "finesse_sim env not found -> creating"
    create_env
fi

echo ""
echo "========================================"
echo " Setup complete!"
echo ""
echo " To launch:"
echo "   bash run.sh"
echo ""
echo " Or manually:"
echo "   conda activate finesse_sim"
echo "   python launcher.py"
echo "========================================"
log "setup done"
