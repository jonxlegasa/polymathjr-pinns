# Documentation Plan for `docs/` Directory

## Project Overview

**Project Name:** PolyMathJr PINN-Jon-Jeet
**Type:** Physics-Informed Neural Networks (PINNs) for ODE Solving
**Primary Language:** Julia (backend) + Python (visualization)
**Purpose:** Train neural networks to approximate solutions of Ordinary Differential Equations (ODEs) using truncated power series coefficients, with supervised learning and ODE residual penalties.

---

## Proposed Directory Structure

```
docs/
├── README.md                           # Documentation index/overview
├── getting-started/
│   ├── installation.md                 # Julia & Python setup
│   ├── quickstart.md                   # First training run walkthrough
│   └── project-structure.md            # File/folder layout explanation
├── architecture/
│   ├── overview.md                     # High-level system architecture
│   ├── pinn-theory.md                  # PINN mathematical background
│   ├── power-series-approach.md        # Why power series coefficients
│   └── data-flow.md                    # How data moves through system
├── julia-modules/
│   ├── main.md                         # src/main.jl documentation
│   ├── pinn.md                         # modelcode/PINN.jl
│   ├── pinn-rnn.md                     # modelcode/PINN_RNN.jl
│   ├── pinn-specific.md                # modelcode/PINN_specific.jl
│   ├── plugboard.md                    # utils/plugboard.jl
│   ├── loss-functions.md               # utils/loss_functions.jl
│   ├── helper-funcs.md                 # utils/helper_funcs.jl
│   ├── training-schemes.md             # utils/training_schemes.jl
│   ├── grid-search.md                  # utils/two_d_grid_search_hyperparameters.jl
│   ├── optimization-search.md          # utils/two_d_grid_optimitze_hyperparameters.jl
│   ├── binary-search.md                # utils/binary_search_on_weights.jl
│   └── progress-bar.md                 # utils/ProgressBar.jl
├── python-modules/
│   ├── visualizer.md                   # scripts/visualizer.py
│   └── main-examples.md                # scripts/main.py
├── api-reference/
│   ├── julia-api.md                    # All Julia function signatures
│   └── python-api.md                   # All Python class/function signatures
├── concepts/
│   ├── loss-components.md              # PDE, BC, Supervised losses explained
│   ├── ode-representation.md           # α matrix format
│   ├── hyperparameter-tuning.md        # Grid search, binary search strategies
│   └── training-workflow.md            # Complete training pipeline
├── data-formats/
│   ├── training-dataset.md             # JSON format for ODEs
│   ├── benchmark-dataset.md            # Evaluation data format
│   ├── output-csv.md                   # Loss CSV structure
│   └── coefficients-json.md            # Python visualization format
└── tutorials/
    ├── custom-ode.md                   # Adding new ODE types
    ├── hyperparameter-search.md        # Running grid/binary search
    ├── visualization-guide.md          # Using Python dashboard
    └── scaling-experiments.md          # Neuron/iteration studies
```

---

## Document Contents (Detailed Breakdown)

### 1. `docs/README.md` - Documentation Index

- Project overview: Physics-Informed Neural Networks for ODE solving
- Navigation to all documentation sections
- Quick links to most important docs
- Version info and last updated dates

---

### 2. `docs/getting-started/`

#### `installation.md`
- Julia installation (v1.9+)
- Python installation (3.14+)
- Installing Julia dependencies via `Project.toml`
- Installing Python dependencies via `uv` or `pip`
- Verifying installation
- GPU setup (CUDA) optional steps

#### `quickstart.md`
- Running first training: `julia src/main.jl`
- Understanding output directories
- Viewing generated plots
- Running Python visualizer
- Expected results explanation

#### `project-structure.md`
- Complete file tree with descriptions
- Purpose of each directory
- Key files to know about
- Where outputs go

---

### 3. `docs/architecture/`

#### `overview.md`
- System diagram showing component relationships
- Julia backend ↔ Python visualization flow
- Training pipeline stages
- Key dependencies

#### `pinn-theory.md`
- What are Physics-Informed Neural Networks
- How PINNs incorporate physics constraints
- Mathematical foundation: embedding PDE residuals in loss
- References to seminal papers (Raissi et al.)

#### `power-series-approach.md`
- Innovation: learning Taylor series coefficients
- Formula: `u(x) ≈ Σ aᵢ · x^i / i!`
- Why factorial normalization
- Advantages over direct function learning
- Derivative computation from coefficients

#### `data-flow.md`
- Input: ODE α matrices + initial conditions
- Process: Network predicts coefficients
- Output: Trained coefficients + loss history
- Visualization: Python dashboard consumption

---

### 4. `docs/julia-modules/`

#### `main.md` (src/main.jl)
- Entry point orchestration
- Training run directory creation
- Batch dataset initialization
- `run_training_sequence()` function
- Configuration options

#### `pinn.md` (modelcode/PINN.jl) - **Most Important**
- `PINNSettings` struct: all 13 fields explained
- `initialize_network()`: Lux chain architecture (input → 6 hidden → output)
- `loss_fn()`: Single-ODE loss computation
- `global_loss()`: Batch aggregation strategy
- `train_pinn()`: ADAM optimization loop with callbacks
- `evaluate_solution()`: Benchmark evaluation + plot generation
- Loss buffer management
- Network architecture diagram

#### `pinn-rnn.md` (modelcode/PINN_RNN.jl)
- GRUCell variant architecture
- Differences from feedforward PINN
- When to use RNN variant
- Current experimental status

#### `pinn-specific.md` (modelcode/PINN_specific.jl)
- Specialized for `ay' + by = 0` form
- Optimizations for this equation class
- Comparison with general PINN

#### `plugboard.md` (utils/plugboard.jl)
- ODE dataset generation system
- `solve_ode_series_closed_form()`: analytical coefficient computation
- `generate_random_ode_dataset()`: random α matrix generation
- Constraint checking: `a² - 4b > 0` for real roots
- Initial condition handling
- Matrix-to-key conversion utilities

#### `loss-functions.md` (utils/loss_functions.jl)
- `LossFunctionSettings` struct
- `generate_loss_pde_value()`: ODE residual at collocation points
- `generate_loss_bc_value()`: boundary condition enforcement
- `generate_loss_supervised_value()`: coefficient MSE
- Mathematical formulas for each loss type
- Weight balancing strategies

#### `helper-funcs.md` (utils/helper_funcs.jl)
- `plugboard_keys_to_vec()`: matrix conversion
- `LossBuffer` type: in-memory loss accumulation
- CSV writing utilities
- `quadratic_formula()`: characteristic equation solving
- Miscellaneous utilities

#### `training-schemes.md` (utils/training_schemes.jl)
- `scaling_neurons()`: varying network width experiments
- `scaling_adam()`: varying iteration count experiments
- `grid_search_at_scale()`: wrapper for 2D searches
- When to use each scheme

#### `grid-search.md` (utils/two_d_grid_search_hyperparameters.jl)
- `GridSearchResult` struct
- 2D weight hyperparameter grid search
- Visualization of results as contour plots
- Configuration options

#### `optimization-search.md` (utils/two_d_grid_optimitze_hyperparameters.jl)
- Optimization-based hyperparameter search
- Differences from grid search
- Algorithm selection

#### `binary-search.md` (utils/binary_search_on_weights.jl)
- Binary search algorithm for single weights
- Directory structure per iteration
- Convergence criteria

#### `progress-bar.md` (utils/ProgressBar.jl)
- ProgressMeter wrapper
- Callback interface for optimization
- Display frequency (every 100 iterations)

---

### 5. `docs/python-modules/`

#### `visualizer.md` (scripts/visualizer.py)
- `GeneralizedVisualizer` class
  - Multi-plot dashboard (1x2, 2x2, 2x3, 3x3 layouts)
  - `PlotConfig` dataclass: all fields
  - `SliderConfig` dataclass: all fields
  - `setup_backend()`: Qt/TkAgg detection
  - Interactive slider mechanics
  - Reset button functionality
- `PowerSeriesVisualizer` class
  - PINN-specific analysis
  - Neuron count slider
  - Loss overlay visualization
  - True vs predicted coefficient comparison
- Example usage patterns

#### `main-examples.md` (scripts/main.py)
- `example_with_loss()`: loading coefficients with loss data
- `example_with_real_data()`: template for real training outputs
- Running the examples
- Expected output

---

### 6. `docs/api-reference/`

#### `julia-api.md`
- Complete function signatures with types
- Parameter descriptions
- Return value documentation
- Example usage for each function
- Organized by module

#### `python-api.md`
- Class method signatures
- Constructor parameters
- Public method documentation
- Type hints explained

---

### 7. `docs/concepts/`

#### `loss-components.md`
- **PDE Loss**: `Σ αₖ · u^(k)(x) = 0` residual
  - Collocation point selection
  - Squared residual computation
  - Averaging strategy
- **BC Loss**: `|u(x₀) - IC₁| + |u'(x₀) - IC₂|`
  - First vs second order handling
  - Why absolute value (not squared) for 1st order
- **Supervised Loss**: `MSE(predicted, true)` for first N coefficients
  - Acceleration effect on training
  - Coefficient count selection
- **Total Loss**: weighted combination
  - Weight balancing strategies
  - Common weight configurations

#### `ode-representation.md`
- α matrix format: `(ode_order+1) × (poly_degree+1)`
- Examples:
  - `[1; -5; 6;;]` → `u'' - 5u' + 6u = 0`
  - `[1; 2;;]` → `u' + 2u = 0`
- String representation convention
- Initial condition pairing

#### `hyperparameter-tuning.md`
- Which hyperparameters matter most
- Grid search workflow
- Binary search workflow
- Analyzing tuning results
- Common pitfalls

#### `training-workflow.md`
- Complete pipeline diagram:
  1. Load ODE dataset
  2. Create PINNSettings
  3. Initialize network
  4. ADAM optimization
  5. (Optional LBFGS)
  6. Benchmark evaluation
  7. Plot generation
- Checkpointing (if applicable)
- Output file locations

---

### 8. `docs/data-formats/`

#### `training-dataset.md`
- JSON schema explanation
- Example with annotations:
```json
{
  "01": {                           // Batch/run identifier
    "[1; -5; 6;;]": [4.0, 2.0, ...], // α matrix → coefficients
    ...
  }
}
```
- How to add new ODEs
- Validation rules

#### `benchmark-dataset.md`
- Single reference ODE format
- Why use a consistent benchmark
- Modifying the benchmark

#### `output-csv.md`
- Loss CSV structure:
```
loss_type | iter_1 | iter_2 | ...
----------|--------|--------|----
total_loss | ... | ... | ...
```
- Reading in Julia/Python
- Plotting from CSV

#### `coefficients-json.md`
- Python visualization format:
```json
{"10": [coeffs], "20": [coeffs], ...}
```
- Neuron count keys
- Integration with visualizer

---

### 9. `docs/tutorials/`

#### `custom-ode.md`
- Adding a new ODE type
- Generating α matrices
- Computing true coefficients
- Adding to training dataset
- Validation steps

#### `hyperparameter-search.md`
- Setting up grid search bounds
- Running the search
- Interpreting contour plots
- Extracting best configuration

#### `visualization-guide.md`
- Installing Python dependencies
- Loading training outputs
- Configuring the dashboard
- Interactive exploration
- Exporting plots

#### `scaling-experiments.md`
- Neuron scaling: 10 → 50 → 100
- Iteration scaling: 500 → 1000 → 10000
- Analyzing convergence
- Memory considerations

---

## Documentation Standards

Each document should include:
1. **Title** with module/file reference
2. **Brief description** (1-2 sentences)
3. **Prerequisites** (what to read first)
4. **Main content** with code examples
5. **See also** links to related docs
6. **Last updated** date

---

## Priority Order for Creation

### Phase 1 - Essential (Core Understanding)
1. `docs/README.md`
2. `docs/getting-started/installation.md`
3. `docs/getting-started/quickstart.md`
4. `docs/architecture/overview.md`
5. `docs/julia-modules/pinn.md`

### Phase 2 - Core Concepts
6. `docs/concepts/loss-components.md`
7. `docs/concepts/ode-representation.md`
8. `docs/julia-modules/plugboard.md`
9. `docs/julia-modules/loss-functions.md`
10. `docs/architecture/power-series-approach.md`

### Phase 3 - Complete Julia Coverage
11-18. Remaining Julia module docs

### Phase 4 - Python & Data
19-22. Python module docs + data format docs

### Phase 5 - Advanced & Tutorials
23-30. API reference + tutorials

---

## Summary

This plan covers **30 documentation files** across **9 directories**, providing complete coverage of:

- **Julia backend**: All 12 source files documented
- **Python frontend**: Both visualization modules
- **Mathematical concepts**: PINN theory, loss functions, power series approach
- **Data formats**: All JSON/CSV structures
- **Practical guides**: 4 tutorials for common tasks

The priority order ensures core understanding comes first, with advanced topics last.
