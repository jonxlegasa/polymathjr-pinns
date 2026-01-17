# PINN.jl

Core PINN implementation for learning power series coefficients.

**Location:** `modelcode/PINN.jl`

---

## PINNSettings Struct

```julia
struct PINNSettings
    neuron_num::Int              # Neurons per hidden layer
    seed::Int                    # Random seed
    ode_matrices::Dict{Any,Any}  # ODE coefficient matrices
    maxiters_adam::Int           # Adam iterations
    n_terms_for_power_series::Int # Degree N of power series
    num_supervised::Int          # Coefficients for supervision
    num_points::Int              # Collocation points
    x_left::Float32              # Domain left boundary
    x_right::Float32             # Domain right boundary
    supervised_weight::Float32   # Weight for supervised loss
    bc_weight::Float32           # Weight for BC loss
    pde_weight::Float32          # Weight for PDE loss
    xs::Any                      # Collocation point locations
end
```

---

## Key Functions

### `initialize_network(settings)`

Creates neural network architecture.

```julia
initialize_network(settings::PINNSettings) → (network, params, state)
```

**Architecture:**
```
Dense(input → neurons, σ) → Dense×6 → Dense(neurons → N+1)
```

---

### `loss_fn(p_net, data, coeff_net, st, ode_matrix_flat, boundary_condition, settings)`

Computes loss for a single ODE.

```julia
loss_fn(...) → (total_loss, state, component_losses)
```

**Components:**
- PDE residual loss
- Boundary condition loss
- Supervised coefficient loss

---

### `global_loss(p_net, settings, coeff_net, st)`

Aggregates loss across all training examples.

```julia
global_loss(...) → (mean_loss, state, aggregated_components)
```

---

### `train_pinn(settings, csv_file)`

Two-stage training: Adam then LBFGS.

```julia
train_pinn(settings::PINNSettings, csv_file) → (trained_params, network, state)
```

**Stages:**
1. Adam: `maxiters_adam` iterations (global exploration)
2. LBFGS: 100 iterations (fine-tuning)

---

### `evaluate_solution(settings, p_trained, coeff_net, st, benchmark_dataset, data_directories)`

Evaluates trained model and generates plots.

```julia
evaluate_solution(...) → nothing
```

**Outputs:**
- Solution comparison plot
- Coefficient comparison plot
- Error analysis plot

---

## Example Usage

```julia
settings = PINNSettings(
    neuron_num = 50,
    seed = 42,
    ode_matrices = training_data,
    maxiters_adam = 10000,
    n_terms_for_power_series = 10,
    num_supervised = 5,
    num_points = 20,
    x_left = 0.0f0,
    x_right = 1.0f0,
    supervised_weight = 0.1f0,
    bc_weight = 1.0f0,
    pde_weight = 1.0f0,
    xs = collect(range(0, 1, 20))
)

p_trained, net, st = train_pinn(settings, "output.csv")
```

---

*See also: [Loss Functions](loss-functions.md), [Training Workflow](../concepts/training-workflow.md)*
