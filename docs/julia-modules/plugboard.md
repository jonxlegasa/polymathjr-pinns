# plugboard.jl

ODE dataset generation using closed-form power series solutions.

**Location:** `utils/plugboard.jl`

---

## Settings Struct

```julia
struct Settings
    ode_order::Int       # Order of ODE (1, 2, ...)
    poly_degree::Int     # Polynomial degree for α matrix
    dataset_size::Int    # Number of ODEs to generate
    data_dir::String     # Output directory
    num_of_terms::Int    # Power series terms to compute
end
```

---

## Key Functions

### `generate_random_alpha_matrix(ode_order, poly_degree)`

Creates random ODE coefficient matrix.

```julia
generate_random_alpha_matrix(ode_order, poly_degree) → Matrix
```

**Example output for 2nd order ODE:**
```julia
[1; -5; 6;;]  # Represents u'' - 5u' + 6u = 0
```

---

### `generate_random_alpha_matrix_with_constraint(ode_order, poly_degree)`

Generates matrices satisfying `a² - 4b > 0` (real roots condition).

---

### `solve_ode_series_closed_form(α_matrix, initial_conditions, num_terms)`

Computes analytical power series coefficients.

```julia
solve_ode_series_closed_form(α, IC, N) → Vector{Float64}
```

**Returns:** `[a₀, a₁, a₂, ..., aₙ]`

Uses the recurrence relation derived from the ODE.

---

### `generate_random_ode_dataset(s, batch_index)`

Creates and saves JSON dataset.

```julia
generate_random_ode_dataset(s::Settings, batch_index) → nothing
```

**Output format:**
```json
{
  "01": {
    "[1; -5; 6;;]": [4.0, 2.0, 1.0, ...],
    ...
  }
}
```

---

### `generate_specific_ode_dataset(s, batch_index, α_matrix)`

Generates dataset from a specific ODE matrix.

---

### `generate_ode_dataset_from_array_of_alpha_matrices(s, batch_index, α_matrices)`

Generates dataset from an array of predefined matrices.

---

## Factorial Product Function

```julia
factorial_product_numeric(n_val, k, i)
```

Computes factorial terms for the ODE recurrence formula:
```
(n-j)(n-j+1)...(n-j+k-1)
```

---

*See also: [ODE Representation](../concepts/ode-representation.md), [Training Dataset](../data-formats/training-dataset.md)*
