# PINN Power Series ODE Solver

A Physics-Informed Neural Network (PINN) that learns **power series coefficients** to approximate solutions of Ordinary Differential Equations (ODEs).

## Overview

Instead of learning the solution function `u(x)` directly, this PINN outputs the coefficients of a truncated power series:

```
u(x) = Σ(i=0 to N) aᵢ · xⁱ / i!
```

The neural network learns to predict `[a₀, a₁, a₂, ..., aₙ]` such that the resulting power series satisfies the ODE.

## Features

- **Power Series Learning**: Neural network outputs Taylor series coefficients
- **Multi-Loss Training**: Combines PDE residual, boundary conditions, and supervised losses
- **Two-Stage Optimization**: Adam for global exploration, LBFGS for fine-tuning
- **Interactive Visualization**: Python dashboard for analyzing results

## Project Structure

```
├── src/main.jl              # Entry point
├── modelcode/
│   ├── PINN.jl              # Core PINN implementation
│   ├── PINN_RNN.jl          # RNN-based variant
│   └── PINN_specific.jl     # Specialized solver
├── utils/
│   ├── plugboard.jl         # ODE dataset generation
│   ├── loss_functions.jl    # Loss computation
│   └── ...                  # Other utilities
├── scripts/
│   ├── visualizer.py        # Interactive visualization
│   └── main.py              # Python examples
├── data/                    # Datasets and outputs
└── docs/                    # Full documentation
```

## Quick Start

```bash
# 1. Clone the repository
git clone git@github.com:jonxlegasa/polymathjr-pinns-jon-jeet.git
cd polymathjr-pinns-jon-jeet

# 2. Install Julia dependencies
julia --project=. -e 'using Pkg; Pkg.instantiate()'

# 3. Run training
julia --project=. src/main.jl
```

## Documentation

Full documentation is available in the [`docs/`](docs/README.md) directory:

- **[Getting Started](docs/getting-started/installation.md)** - Installation and quickstart
- **[Architecture](docs/architecture/overview.md)** - System design and PINN theory
- **[Julia Modules](docs/julia-modules/pinn.md)** - Code documentation
- **[Concepts](docs/concepts/loss-components.md)** - Mathematical background
- **[Tutorials](docs/tutorials/custom-ode.md)** - Step-by-step guides
- **[API Reference](docs/api-reference/julia-api.md)** - Function signatures

## How It Works

1. **Dataset Generation**: `plugboard.jl` creates ODEs and computes analytical power series coefficients
2. **Network Training**: PINN learns to predict coefficients that satisfy ODE constraints
3. **Loss Function**: Combines PDE residual + boundary conditions + supervised coefficient loss
4. **Evaluation**: Compares predicted vs true coefficients on benchmark ODE

### Loss Components

```
Total Loss = pde_weight × L_pde + bc_weight × L_bc + sup_weight × L_supervised
```

- **L_pde**: ODE residual at collocation points
- **L_bc**: Boundary condition enforcement
- **L_supervised**: MSE of predicted vs true coefficients

## Example ODE

For `u'' - 5u' + 6u = 0` with `u(0) = 4, u'(0) = 2`:

- α matrix: `[1; -5; 6;;]`
- True coefficients: `[4.0, 2.0, 1.0, 1.333, ...]`
- PINN learns to output these coefficients

## Python Visualization

```bash
cd scripts
python -m venv .venv
source .venv/bin/activate
pip install numpy matplotlib
python main.py
```

## Technology Stack

| Component | Technology |
|-----------|------------|
| Backend | Julia 1.9+ |
| Neural Networks | Lux.jl |
| Optimization | Optimization.jl (Adam, LBFGS) |
| Autodiff | Zygote.jl |
| Visualization | Python / Matplotlib |

## License

MIT

## Citation

If you use this code in your research, please cite:

```bibtex
@software{polymathjr_pinn,
  title = {PINN Power Series ODE Solver},
  author = {PolyMathJr Team},
  year = {2026},
  url = {https://github.com/jonxlegasa/polymathjr-pinns-jon-jeet}
}
```
