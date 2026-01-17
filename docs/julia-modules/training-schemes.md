# training_schemes.jl

Training strategies for hyperparameter exploration.

**Location:** `utils/training_schemes.jl`

---

## TrainingSchemesSettings Struct

```julia
struct TrainingSchemesSettings
    training_dataset::Dict{String,Dict{String,Any}}
    benchmark_dataset::Dict{String,Dict{String,Any}}
    N::Int                      # Power series degree
    num_supervised::Int
    num_points::Int
    x_left::Float32
    x_right::Float32
    supervised_weight::Float32
    bc_weight::Float32
    pde_weight::Float32
    xs::Vector{Float32}
end
```

---

## Training Functions

### `scaling_neurons(settings, neurons_counts)`

Trains separate PINNs with different neuron counts.

```julia
scaling_neurons(settings, neurons_counts::Dict)
```

**Example:**
```julia
neurons_counts = Dict(10 => "small", 50 => "medium", 100 => "large")
scaling_neurons(settings, neurons_counts)
```

Creates separate training runs for each neuron count.

---

### `scaling_adam(settings, iteration_counts)`

Trains with different Adam iteration counts.

```julia
scaling_adam(settings, iteration_counts::Dict)
```

**Example:**
```julia
iteration_counts = Dict(1000 => "short", 10000 => "medium", 50000 => "long")
scaling_adam(settings, iteration_counts)
```

---

### `grid_search_at_scale(settings, neurons_counts)`

2D grid search over loss weights at different network scales.

```julia
grid_search_at_scale(settings, neurons_counts::Dict)
```

Combines neuron scaling with hyperparameter grid search.

---

## Use Cases

| Function | Use Case |
|----------|----------|
| `scaling_neurons` | Find optimal network size |
| `scaling_adam` | Determine convergence iterations |
| `grid_search_at_scale` | Full hyperparameter optimization |

---

*See also: [Hyperparameter Tuning](../concepts/hyperparameter-tuning.md), [Scaling Experiments Tutorial](../tutorials/scaling-experiments.md)*
