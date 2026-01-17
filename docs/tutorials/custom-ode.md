# Tutorial: Adding Custom ODEs

How to add new ODE types to the training system.

---

## Overview

This tutorial covers:
1. Creating an α matrix for your ODE
2. Computing analytical coefficients
3. Adding to training dataset
4. Validating the solution

---

## Step 1: Define Your ODE

Express your ODE in standard form:

```
Σ(k=0 to m) αₖ × u^(k)(x) = 0
```

**Example:** `u'' - 3u' + 2u = 0`

This gives us:
- α₂ = 1 (coefficient of u'')
- α₁ = -3 (coefficient of u')
- α₀ = 2 (coefficient of u)

---

## Step 2: Create α Matrix

```julia
α = [1; -3; 2;;]  # Column vector for constant coefficients
```

**For variable coefficients** (e.g., `xu'' + u' + u = 0`):
```julia
α = [0 1; 1 0; 1 0]  # Each column is a polynomial degree
```

---

## Step 3: Choose Initial Conditions

For a 2nd order ODE, you need:
```julia
IC = [u(0), u'(0)]
```

**Example:**
```julia
IC = [1.0, 0.0]  # u(0) = 1, u'(0) = 0
```

---

## Step 4: Compute Power Series Coefficients

```julia
using JSON
include("utils/plugboard.jl")

α = [1; -3; 2;;]
IC = [1.0, 0.0]
num_terms = 15

coeffs = solve_ode_series_closed_form(α, IC, num_terms)
println("Coefficients: ", coeffs)
```

---

## Step 5: Add to Training Dataset

### Option A: Manual Addition

Edit `data/training_dataset.json`:

```json
{
  "01": {
    "[1; -3; 2;;]": [1.0, 0.0, 0.5, 0.25, ...],
    // ... other ODEs
  }
}
```

### Option B: Programmatic Addition

```julia
include("utils/plugboard.jl")

settings = Settings(
    ode_order = 2,
    poly_degree = 0,
    dataset_size = 1,
    data_dir = "data",
    num_of_terms = 15
)

α_matrix = [1; -3; 2;;]
generate_specific_ode_dataset(settings, 1, α_matrix)
```

---

## Step 6: Validate

### Check Coefficient Accuracy

```julia
# Verify coefficients satisfy ODE
# For u'' - 3u' + 2u = 0:
# a_{n+2} - 3*a_{n+1} + 2*a_n = 0 (recurrence relation)

a = coeffs
for n in 1:(length(a)-2)
    residual = a[n+2] - 3*a[n+1] + 2*a[n]
    @assert abs(residual) < 1e-10 "Recurrence violated at n=$n"
end
```

### Check Initial Conditions

```julia
@assert coeffs[1] == IC[1]  # a₀ = u(0)
@assert coeffs[2] == IC[2]  # a₁ = u'(0)
```

---

## Step 7: Train and Evaluate

```julia
# Update main.jl to use your dataset
# Then run:
# julia --project=. src/main.jl
```

---

## Common ODE Examples

| ODE | α Matrix | Notes |
|-----|----------|-------|
| u' + u = 0 | `[1; 1;;]` | Exponential decay |
| u'' + u = 0 | `[1; 0; 1;;]` | Harmonic oscillator |
| u'' - u = 0 | `[1; 0; -1;;]` | Hyperbolic functions |
| u'' - 5u' + 6u = 0 | `[1; -5; 6;;]` | Default example |

---

## Troubleshooting

**Problem:** Coefficients explode for large n

**Solution:** Check discriminant constraint. For `au'' + bu' + cu = 0`, need `b² - 4ac > 0` for real roots.

**Problem:** Training doesn't converge

**Solution:**
- Increase `maxiters_adam`
- Adjust loss weights
- Check if ODE has unique solution

---

*See also: [ODE Representation](../concepts/ode-representation.md), [plugboard.jl](../julia-modules/plugboard.md)*
