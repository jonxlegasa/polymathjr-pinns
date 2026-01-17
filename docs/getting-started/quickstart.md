# Quickstart

Run your first PINN training.

## Run Training

```bash
julia --project=. src/main.jl
```

This will:
1. Generate ODE training dataset
2. Initialize neural network
3. Train with Adam optimizer
4. Fine-tune with LBFGS
5. Evaluate and save plots

---

## Output Structure

```
data/training-run-1/
├── batch-01/
│   ├── iteration_output.csv    # Loss history
│   ├── solution_plot.png       # Solution comparison
│   ├── coefficient_plot.png    # Coefficient comparison
│   └── error_plot.png          # Error analysis
└── metadata.json
```

---

## View Results

### Loss CSV Format

```csv
loss_type,iter_1,iter_2,...
total_loss,0.95,0.82,...
total_loss_bc,0.30,0.25,...
total_loss_pde,0.50,0.42,...
total_loss_supervised,0.15,0.15,...
```

### Interactive Visualization

```bash
cd scripts
source .venv/bin/activate
python main.py
```

---

## Configuration

Modify `src/main.jl`:

```julia
neuron_num = 50              # Hidden layer width
maxiters_adam = 10000        # Adam iterations
n_terms_for_power_series = 10  # Power series degree N
supervised_weight = 0.1f0    # Supervised loss weight
bc_weight = 1.0f0            # Boundary condition weight
pde_weight = 1.0f0           # PDE residual weight
```

---

*Next: [Project Structure](project-structure.md)*
