# Training Dataset Format

JSON format for ODE training examples.

**Location:** `data/training_dataset.json`

---

## Structure

```json
{
  "01": {
    "[1; -5; 6;;]": [4.0, 2.0, 1.0, 1.333, ...],
    "[1; 8; 10;;]": [1.0, 2.0, -1.7, 2.52, ...],
    ...
  },
  "02": {
    ...
  }
}
```

---

## Schema

| Level | Key | Value |
|-------|-----|-------|
| Outer | Batch index ("01", "02") | Dictionary of ODEs |
| Inner | α matrix string | Array of coefficients |

---

## Components

### Batch Index

Zero-padded string identifier for dataset batches.

```
"01", "02", ..., "10", "11", ...
```

### α Matrix String

ODE coefficient matrix in Julia literal format.

```
"[1; -5; 6;;]" → u'' - 5u' + 6u = 0
```

### Coefficient Array

Power series coefficients `[a₀, a₁, a₂, ..., aₙ]`:

```json
[4.0, 2.0, 1.0, 1.333, 2.333, 4.111, ...]
```

Where:
- `a₀ = u(0)` (initial value)
- `a₁ = u'(0)` (initial derivative)
- `aₙ` computed from ODE recurrence

---

## Example Entry

**ODE:** `u'' - 5u' + 6u = 0` with `u(0) = 4, u'(0) = 2`

```json
{
  "01": {
    "[1; -5; 6;;]": [
      4.0,      // a₀ = u(0)
      2.0,      // a₁ = u'(0)
      1.0,      // a₂
      1.333,    // a₃
      2.333,    // a₄
      4.111,    // a₅
      // ... more coefficients
    ]
  }
}
```

---

## Adding New ODEs

1. Create α matrix for your ODE
2. Compute initial conditions
3. Use `generate_specific_ode_dataset()` or manually add to JSON

```julia
# In Julia
α = [1; -3; 2;;]  # u'' - 3u' + 2u = 0
IC = [1.0, 0.0]   # u(0) = 1, u'(0) = 0
coeffs = solve_ode_series_closed_form(α, IC, 15)
```

---

## Validation

- α matrix must match ODE order
- Initial conditions must match ODE order
- Coefficients should satisfy ODE (verify with residual check)

---

*See also: [ODE Representation](../concepts/ode-representation.md), [plugboard.jl](../julia-modules/plugboard.md)*
