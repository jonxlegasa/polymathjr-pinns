# loss_functions.jl

Modular loss computation for PINN training.

**Location:** `utils/loss_functions.jl`

---

## LossFunctionSettings Struct

```julia
struct LossFunctionSettings
    a_vec::Vector{Float32}           # Network's coefficient output
    n_terms_for_power_series::Int    # Power series degree N
    ode_matrix_flat::Vector{Float32} # Flattened ODE matrix
    x_left::Float32                  # Left boundary
    boundary_condition::Array{Float32} # Initial conditions
    xs::Vector{Float32}              # Collocation points
    num_points::Int                  # Number of collocation points
    num_supervised::Int              # Supervised coefficients
    data::Vector{Float32}            # Ground truth coefficients
end
```

---

## Loss Functions

### `generate_loss_pde_value(settings)`

Computes PDE residual loss.

```julia
generate_loss_pde_value(settings) → Float32
```

**Formula:**
```
L_pde = (1/num_points) × Σ |R(xᵢ)|²
```

Where `R(x)` is the ODE residual at collocation point `x`.

---

### `generate_loss_bc_value(settings)`

Computes boundary condition loss.

```julia
generate_loss_bc_value(settings) → Float32
```

**Formula:**
```
L_bc = |u(x₀) - IC₁| + |u'(x₀) - IC₂|
```

Uses absolute value (not squared) for first-order terms.

---

### `generate_loss_supervised_value(settings)`

Computes supervised coefficient MSE.

```julia
generate_loss_supervised_value(settings) → Float32
```

**Formula:**
```
L_sup = (1/num_supervised) × Σ |aᵢ_pred - aᵢ_true|²
```

Only supervises first `num_supervised` coefficients.

---

## Helper Functions

### `ode_residual(settings, x)`

Computes ODE residual at point x.

```julia
ode_residual(settings, x) → Float32
```

---

### `generate_u_approx(settings)`

Creates power series approximation function.

```julia
generate_u_approx(settings) → Function
```

Returns function `u(x)` that evaluates the power series.

---

## Mathematical Details

**Power series:**
```
u(x) = Σ(i=0 to N) aᵢ × xⁱ / i!
```

**k-th derivative:**
```
u^(k)(x) = Σ(i=k to N) aᵢ × xⁱ⁻ᵏ / (i-k)!
```

**ODE residual:**
```
R(x) = Σ(k=0 to m) αₖ × u^(k)(x)
```

---

*See also: [Loss Components](../concepts/loss-components.md), [PINN.jl](pinn.md)*
