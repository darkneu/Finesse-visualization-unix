#!/usr/bin/env bash
# Finesse3 Optics Simulator — macOS / Linux Launcher
# Usage: bash run.sh
#
# This is the POSIX port of run.ps1. It:
#   * locates the finesse_sim conda env (PATH, then well-known locations)
#   * picks a free port starting from 5000
#   * opens the browser once the server is ready
#   * runs the Flask server in this terminal (Ctrl+C to stop)

set -euo pipefail
cd "$(dirname "$0")"

echo "Optics Simulator starting..."

# ---------------------------------------------------------------------------
# Locate conda and activate the finesse_sim env.
# ---------------------------------------------------------------------------
if [ -z "${CONDA_PREFIX:-}" ] || [ "$(basename "${CONDA_PREFIX:-}")" != "finesse_sim" ]; then
    CONDA_BASE=""
    if command -v conda >/dev/null 2>&1; then
        CONDA_BASE="$(conda info --base 2>/dev/null | tr -d '"' | tr -d '\r')" || true
    fi
    if [ -z "$CONDA_BASE" ] || [ ! -f "$CONDA_BASE/etc/profile.d/conda.sh" ]; then
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
        echo "ERROR: conda not found. Run 'bash setup.sh' first."
        exit 1
    fi

    # shellcheck disable=SC1091
    source "$CONDA_BASE/etc/profile.d/conda.sh"
    conda activate finesse_sim 2>/dev/null || {
        echo "ERROR: conda environment 'finesse_sim' not found."
        echo "Run 'bash setup.sh' first to create it."
        exit 1
    }
fi

# ---------------------------------------------------------------------------
# Pick a free port starting from 5000.
# ---------------------------------------------------------------------------
PORT=5000
while [ "$PORT" -le 5100 ]; do
    if command -v lsof >/dev/null 2>&1; then
        if ! lsof -i :"$PORT" -sTCP:LISTEN -t >/dev/null 2>&1; then
            break
        fi
    else
        # Fallback: try to connect with bash's /dev/tcp.
        if ! (exec 3<>"/dev/tcp/127.0.0.1/$PORT") 2>/dev/null; then
            break
        fi
        exec 3>&- 2>/dev/null || true
    fi
    PORT=$((PORT + 1))
done
echo "Using port: $PORT"

# ---------------------------------------------------------------------------
# Open the browser once the port is accepting connections (background poller).
# ---------------------------------------------------------------------------
open_browser_when_ready() {
    local port="$1"
    for _ in $(seq 1 90); do
        if command -v lsof >/dev/null 2>&1; then
            if lsof -i :"$port" -sTCP:LISTEN -t >/dev/null 2>&1; then
                break
            fi
        else
            if (exec 3<>"/dev/tcp/127.0.0.1/$port") 2>/dev/null; then
                exec 3>&- 2>/dev/null || true
                break
            fi
        fi
        sleep 1
    done
    local url="http://localhost:$port"
    if command -v open >/dev/null 2>&1; then
        open "$url" 2>/dev/null || true          # macOS
    elif command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$url" 2>/dev/null || true      # Linux
    fi
}
open_browser_when_ready "$PORT" &

echo ""
python launcher.py --no-browser --port "$PORT"
echo "Server stopped."
