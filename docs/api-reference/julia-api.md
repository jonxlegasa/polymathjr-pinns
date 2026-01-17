# Julia API Reference

Complete function signatures for all Julia modules.

---

## PINN.jl

### Structs

```julia
struct PINNSettings
    neuron_num::Int
    seed::Int
    ode_matrices::Dict{Any,Any}
    maxiters_adam::Int
    n_terms_for_power_series::Int
    num_supervised::Int
    num_points::Int
    x_left::Float32
    x_right::Float32
    supervised_weight::Float32
    bc_weight::Float32
    pde_weight::Float32
    xs::Any
end
```

### Functions

```julia
initialize_network(settings::PINNSettings) → (Chain, ComponentArray, NamedTuple)
```
Creates Lux neural network with specified architecture.

```julia
loss_fn(p_net, data, coeff_net, st, ode_matrix_flat, boundary_condition, settings)
    → (Float32, NamedTuple, NamedTuple)
```
Computes loss for single ODE. Returns (total_loss, state, components).

```julia
global_loss(p_net, settings, coeff_net, st) → (Float32, NamedTuple, NamedTuple)
```
Aggregates loss across all training examples.

```julia
train_pinn(settings::PINNSettings, csv_file::String)
    → (ComponentArray, Chain, NamedTuple)
```
Trains PINN with Adam + LBFGS. Returns trained parameters.

```julia
evaluate_solution(settings, p_trained, coeff_net, st, benchmark_dataset, data_directories)
    → nothing
```
Evaluates model and generates plots.

---

## plugboard.jl

### Structs

```julia
struct Settings
    ode_order::Int
    poly_degree::Int
    dataset_size::Int
    data_dir::String
    num_of_terms::Int
end
```

### Functions

```julia
generate_random_alpha_matrix(ode_order::Int, poly_degree::Int) → Matrix
```
Creates random ODE coefficient matrix.

```julia
generate_random_alpha_matrix_with_constraint(ode_order::Int, poly_degree::Int) → Matrix
```
Generates matrix satisfying discriminant constraint.

```julia
solve_ode_series_closed_form(α_matrix, initial_conditions, num_terms::Int)
    → Vector{Float64}
```
Computes analytical power series coefficients.

```julia
generate_random_ode_dataset(s::Settings, batch_index::Int) → nothing
```
Creates and saves JSON dataset.

```julia
generate_specific_ode_dataset(s::Settings, batch_index::Int, α_matrix) → nothing
```
Generates dataset from specific ODE.

```julia
generate_ode_dataset_from_array_of_alpha_matrices(s::Settings, batch_index::Int, α_matrices)
    → nothing
```
Generates from array of matrices.

```julia
factorial_product_numeric(n_val::Int, k::Int, i::Int) → Float64
```
Computes factorial product terms.

---

## loss_functions.jl

### Structs

```julia
struct LossFunctionSettings
    a_vec::Vector{Float32}
    n_terms_for_power_series::Int
    ode_matrix_flat::Vector{Float32}
    x_left::Float32
    boundary_condition::Array{Float32}
    xs::Vector{Float32}
    num_points::Int
    num_supervised::Int
    data::Vector{Float32}
end
```

### Functions

```julia
ode_residual(settings::LossFunctionSettings, x::Float32) → Float32
```
Computes ODE residual at point x.

```julia
generate_u_approx(settings::LossFunctionSettings) → Function
```
Creates power series approximation function.

```julia
generate_loss_pde_value(settings::LossFunctionSettings) → Float32
```
Computes PDE residual loss.

```julia
generate_loss_bc_value(settings::LossFunctionSettings) → Float32
```
Computes boundary condition loss.

```julia
generate_loss_supervised_value(settings::LossFunctionSettings) → Float32
```
Computes supervised coefficient MSE.

---

## helper_funcs.jl

### Functions

```julia
convert_plugboard_keys(inner_dict::Dict) → Dict
```
Converts string keys to Julia matrices.

```julia
initialize_loss_buffer() → nothing
```
Initializes loss tracking buffer.

```julia
buffer_loss_values(; kwargs...) → nothing
```
Adds loss values to buffer.

```julia
write_buffer_to_csv(csv_file::String) → nothing
```
Writes buffer to CSV.

```julia
get_buffer_size() → Int
```
Returns buffer entry count.

```julia
quadratic_formula(a, b, c) → Tuple{Float64, Float64}
```
Solves quadratic equation.

```julia
generate_valid_matrix() → Matrix
```
Generates random matrix with real roots.

```julia
create_matrix_array(n::Int) → Vector{Matrix}
```
Creates n random valid matrices.

---

## training_schemes.jl

### Structs

```julia
struct TrainingSchemesSettings
    training_dataset::Dict{String,Dict{String,Any}}
    benchmark_dataset::Dict{String,Dict{String,Any}}
    N::Int
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

### Functions

```julia
scaling_neurons(settings, neurons_counts::Dict) → nothing
```
Trains with different neuron counts.

```julia
scaling_adam(settings, iteration_counts::Dict) → nothing
```
Trains with different iteration counts.

```julia
grid_search_at_scale(settings, neurons_counts::Dict) → nothing
```
2D grid search at different scales.

---

## ProgressBar.jl

### Structs

```julia
struct ProgressBarSettings
    maxiters::Int
    message::String
end
```

### Functions

```julia
Bar(s::ProgressBarSettings) → Function
```
Creates optimization callback.

---

## main.jl

### Functions

```julia
create_training_run_dirs(run_number::Int64, batch_size::Any) → String
```
Creates output directory structure.

```julia
init_batches(batch_sizes::Array{Int}) → nothing
```
Initializes training datasets.

```julia
run_training_sequence(batch_sizes::Array{Int}) → nothing
```
Main orchestration function.

---

*See also: [Python API](python-api.md)*
