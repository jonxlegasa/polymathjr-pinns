# ODE Representation

How ODEs are encoded as α matrices in this system.

---

## α Matrix Format

An ODE is represented as a matrix of shape `(ode_order + 1) × (poly_degree + 1)`.

For constant-coefficient ODEs (poly_degree = 0), this simplifies to a column vector.

---

## Examples

### Second-Order ODE

**ODE:** `u'' - 5u' + 6u = 0`

**α matrix (string format):**
```
"[1; -5; 6;;]"
```

**Interpretation:**
```
α₂ = 1   (coefficient of u'')
α₁ = -5  (coefficient of u')
α₀ = 6   (coefficient of u)
```

**General form:** `α₂u'' + α₁u' + α₀u = 0`

---

### First-Order ODE

**ODE:** `u' + 2u = 0`

**α matrix:**
```
"[1; 2;;]"
```

**Interpretation:**
```
α₁ = 1  (coefficient of u')
α₀ = 2  (coefficient of u)
```

---

## Initial Conditions

Paired with each α matrix as an array:

```
[u(0), u'(0), ...]
```

**Example for 2nd order:**
```julia
α = "[1; -5; 6;;]"
IC = [4.0, 2.0]  # u(0) = 4, u'(0) = 2
```

---

## String Representation Convention

The string format `"[1; -5; 6;;]"` uses Julia matrix literal syntax:
- `;` separates rows
- `;;` ends the matrix (single column)

This allows matrices to be used as dictionary keys in JSON.

---

## Variable Coefficient ODEs

For variable coefficients (poly_degree > 0):

**ODE:** `xu'' + (1-x)u' + u = 0`

**α matrix:**
```
[0 1; 1 -1; 1 0]
```

Where columns represent polynomial degrees of x.

---

## Converting Keys

The `convert_plugboard_keys()` function in `helper_funcs.jl` converts string representations back to Julia matrices:

```julia
"[1; -5; 6;;]" → Matrix([1, -5, 6])
```

---

*See also: [plugboard.jl](../julia-modules/plugboard.md), [Training Dataset](../data-formats/training-dataset.md)*
