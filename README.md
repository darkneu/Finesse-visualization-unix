# Finesse3 Optics Simulator — macOS / Linux Edition

> Drag-and-drop optical interferometer designer for [Finesse 3](https://finesse.ifosim.org/). Build a layout on the canvas, click **Run**, and get a live KatScript preview, simulation plots, and exportable notebooks.

[![License: GPLv3](https://img.shields.io/badge/license-GPLv3-blue)](LICENSE)
[![Python](https://img.shields.io/badge/python-3.12-green)](https://www.python.org/)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-lightgrey)]()
[![UI](https://img.shields.io/badge/UI-English%20%7C%20中文-orange)]()

**Install:** `bash setup.sh` → **Run:** `bash run.sh` → open `http://localhost:5000`

---

## About this project

This is a **macOS / Linux (POSIX) edition** of the Finesse visualization tool, adapted
from the original project:

> **Original project:** [https://github.com/leelans/Finesse-visualization](https://github.com/leelans/Finesse-visualization)

The original repository targets Windows. This edition keeps the same simulation engine,
component registry, web UI and examples, and adds:

- **Cross-platform launcher** — a POSIX `launcher.py` plus `setup.sh` / `run.sh` bash
  scripts that work on macOS and Linux (no `.bat` / `.ps1` required).
- **Bilingual UI (English / 中文)** — a built-in language toggle in the top-right corner
  of both the main editor and the Jupyter window. The choice is remembered in
  `localStorage`, so the UI stays in your preferred language across sessions.

### What changed vs. the original (Windows) version

| Original (Windows) | This edition (macOS / Linux) |
|--------------------|------------------------------|
| `setup.bat` / `setup.ps1` | `setup.sh` (bash) |
| `run.bat` / `run.ps1` | `run.sh` (bash) |
| `launcher.py` with `win32` DLL handling and `Lib\site-packages` probing | `launcher.py` using POSIX `lib/pythonX.Y/site-packages` and `bin/python` |
| `python.exe` | `python` / `python3` |
| `%TEMP%` logs | `${TMPDIR:-/tmp}` logs |
| `start` / `Start-Process` browser launch | `open` (macOS) / `xdg-open` (Linux) |
| English-only UI | English + 中文 with a runtime toggle |

---

## Quick Start

### Prerequisites

- [Miniconda](https://docs.conda.io/en/latest/miniconda.html) (macOS or Linux)
- A dedicated `finesse_sim` conda environment (finesse 3.x + flask), created automatically by `setup.sh`. **Do NOT use the `finesse` env** — it does not have flask installed, and the app will fail to start.

### Install & Launch

Open a terminal in this folder and run:

```bash
bash setup.sh      # Install everything (one time)
bash run.sh        # Launch — opens http://localhost:5000
```

If port 5000 is in use, the next available port is selected automatically.

> **Tip:** make the scripts executable once with `chmod +x setup.sh run.sh` and you
> can then run them as `./setup.sh` and `./run.sh`.

---

## Features

- **Visual layout** — 12 component types: laser, mirror, beamsplitter, lens, modulator, isolator, photodetector, CCD, cavity, gauss, amplitude detector, and custom KatScript components
- **KatScript generation** — real-time Finesse 3 script preview
- **Variables & expressions** — define Python variables with `numpy`, reference them in parameters with `{var}` syntax
- **Import from Jupyter** — paste entire notebook cells; the importer strips non-model code, evaluates Python variables, and parses KatScript blocks automatically
- **Simulation** — static (`noxaxis`) and parameter sweep (`xaxis`) with Chart.js plots
- **Export** — `.kat`, `.ipynb` (Jupyter notebook), and JSON state files
- **Bilingual UI** — switch between English and 中文 at any time
- **Light / dark theme**

Full documentation: [USER_MANUAL.pdf](USER_MANUAL.pdf) (3 Michelson interferometer examples included).

---

## Language / 语言

Click the **EN / 中** button in the top-right corner of the header to switch the entire
interface between English and Chinese. The setting is saved in your browser and applies
to both the main editor and the Jupyter window.

点击标题栏右上角的 **EN / 中** 按钮即可在英文与中文之间切换整个界面。该设置会保存在浏览器中，
并同时作用于主编辑器和 Jupyter 窗口。

---

## Troubleshooting

- **`conda: command not found`** — install Miniconda, or run `source ~/miniconda3/etc/profile.d/conda.sh` first. `setup.sh` / `run.sh` also scan common install locations automatically.
- **`conda environment 'finesse_sim' not found`** — run `bash setup.sh` first.
- **Port already in use** — the scripts auto-select the next free port (5000–5100).
- **Logs** — setup logs go to `${TMPDIR:-/tmp}/finesse_setup.log`; the app writes `optics-sim.log` next to `launcher.py`.
- **Apple Silicon** — the conda-forge `finesse` package provides native arm64 builds; no Rosetta required.

---

## Acknowledgements

This project is adapted from **[leelans/Finesse-visualization](https://github.com/leelans/Finesse-visualization)**.
Thanks to the original author for the visual editor, component registry and web UI that
form the foundation of this edition.

It is built on **[Finesse 3](https://finesse.ifosim.org/)** ([repo](https://gitlab.com/ifosim/finesse/finesse3)),
the frequency-domain interferometer simulation engine developed by the LIGO Scientific
Collaboration and maintained by the Finesse team at Nikhef. Finesse 3 is licensed under GPLv3.

The majority of the source code in this repository was generated with the assistance of
large language models (LLMs), including DeepSeek and Claude, under human direction and review.

---

## Dependencies

| Package | Use | License |
|---------|-----|---------|
| [Finesse 3](https://finesse.ifosim.org/) | Simulation engine | GPLv3 |
| [Flask](https://flask.palletsprojects.com/) | Web server | BSD |
| [NumPy](https://numpy.org/) | Numerical computation | BSD |
| [PlaneGCS](https://github.com/salusoft89/planegcs) | Constraint solver | MIT |
| [Chart.js](https://www.chartjs.org/) | Plotting (CDN) | MIT |

---

## License

GPLv3 — see [LICENSE](LICENSE). This project uses [Finesse 3](https://gitlab.com/ifosim/finesse/finesse3) (also GPLv3)
and is adapted from [leelans/Finesse-visualization](https://github.com/leelans/Finesse-visualization).
