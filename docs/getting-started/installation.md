# Installation

Set up Julia (backend) and Python (visualization) environments.

## Prerequisites

- Julia 1.9+
- Python 3.14+
- Git

---

## Julia Setup

### 1. Clone Repository

```bash
git clone git@github.com:jonxlegasa/polymathjr-pinns-jon-jeet.git
cd polymathjr-pinns-jon-jeet
```

### 2. Install Dependencies

```bash
julia --project=. -e 'using Pkg; Pkg.instantiate()'
```

Key packages installed:

| Package | Purpose |
|---------|---------|
| Lux | Neural network layers |
| Optimization | Optimization framework |
| OptimizationOptimJL | LBFGS optimizer |
| OptimizationOptimisers | Adam optimizer |
| Zygote | Automatic differentiation |
| JSON, CSV | Data I/O |
| Plots | Visualization |
| TaylorSeries | Power series operations |

### 3. Verify

```bash
julia --project=. -e 'using Lux, Optimization; println("Success!")'
```

---

## Python Setup

```bash
cd scripts
python -m venv .venv
source .venv/bin/activate
pip install numpy matplotlib
```

---

## GPU Setup (Optional)

```bash
julia --project=. -e 'using Pkg; Pkg.add("CUDA")'
```

---

*Next: [Quickstart](quickstart.md)*
