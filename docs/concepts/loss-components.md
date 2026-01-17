# Loss Components

The total loss combines three components: PDE residual, boundary conditions, and supervised coefficients.

---

## Total Loss Formula

```
L_total = pde_weight × L_pde + bc_weight × L_bc + sup_weight × L_supervised
```

Default weights: `pde_weight = 1.0`, `bc_weight = 1.0`, `sup_weight = 0.1`

---

## PDE Loss (Physics Loss)

Enforces that the learned solution satisfies the ODE.

**Formula:**
```
L_pde = (1/num_points) × Σᵢ |R(xᵢ)|²
```

Where `R(x)` is the ODE residual:
```
R(x) = Σ(k=0 to m) αₖ × u^(k)(x)
```

**Collocation points:** Evenly spaced in `[x_left, x_right]`

---

## Boundary Condition Loss

Enforces initial/boundary conditions.

**For 2nd order ODE:**
```
L_bc = |u(x₀) - IC₁| + |u'(x₀) - IC₂|
```

**Notes:**
- Uses absolute value (L1) not squared (L2) for individual terms
- First condition: function value at boundary
- Second condition: derivative value at boundary

---

## Supervised Loss

Accelerates training by providing ground truth coefficients.

**Formula:**
```
L_supervised = (1/num_supervised) × Σ(i=0 to num_supervised-1) |aᵢ_pred - aᵢ_true|²
```

**Notes:**
- Only supervises first `num_supervised` coefficients
- Remaining coefficients learned from PDE constraint
- Typical value: `num_supervised = 5` for degree-10 series

---

## Weight Balancing

| Weight | Effect |
|--------|--------|
| Higher `pde_weight` | Stricter physics enforcement |
| Higher `bc_weight` | Better initial condition matching |
| Higher `sup_weight` | Faster convergence, potential overfitting |

**Common configurations:**

| Use Case | PDE | BC | Supervised |
|----------|-----|-----|------------|
| Physics-driven | 1.0 | 1.0 | 0.0 |
| Balanced | 1.0 | 1.0 | 0.1 |
| Data-driven | 0.1 | 1.0 | 1.0 |

---

## Derivative Computation

Derivatives computed from power series coefficients:

```
u(x)   = a₀ + a₁x/1! + a₂x²/2! + ...
u'(x)  = a₁ + a₂x/1! + a₃x²/2! + ...
u''(x) = a₂ + a₃x/1! + a₄x²/2! + ...
```

General formula:
```
u^(k)(x) = Σ(i=k to N) aᵢ × xⁱ⁻ᵏ / (i-k)!
```

---

*See also: [loss_functions.jl](../julia-modules/loss-functions.md), [Power Series Approach](../architecture/power-series-approach.md)*
