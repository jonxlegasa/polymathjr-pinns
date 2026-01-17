# Power Series Approach

## Why Power Series Coefficients?

Traditional PINNs learn the function `u(x)` directly and compute derivatives via automatic differentiation. Our approach learns the **power series coefficients** instead.

---

## Power Series Representation

The solution is represented as:
```
u(x) = Σ(i=0 to N) aᵢ · xⁱ / i!
```

Where:
- `aᵢ` = i-th coefficient (learned by neural network)
- `N` = polynomial degree (hyperparameter)
- `i!` = factorial normalization

---

## Factorial Normalization

We use `xⁱ/i!` instead of `xⁱ` because:

1. **Connection to Taylor series**: For analytic solutions, `aᵢ = u^(i)(0)` (i-th derivative at origin)
2. **Numerical stability**: Prevents coefficient explosion for large `i`
3. **Physical meaning**: `a₀ = u(0)`, `a₁ = u'(0)`, etc.

---

## Derivative Computation

Derivatives are computed exactly from coefficients:

```
u(x)   = a₀ + a₁·x/1! + a₂·x²/2! + a₃·x³/3! + ...
u'(x)  = a₁ + a₂·x/1! + a₃·x²/2! + a₄·x³/3! + ...
u''(x) = a₂ + a₃·x/1! + a₄·x²/2! + a₅·x³/3! + ...
```

General formula:
```
u^(k)(x) = Σ(i=k to N) aᵢ · xⁱ⁻ᵏ / (i-k)!
```

---

## Advantages

| Aspect | Direct Function Learning | Power Series Coefficients |
|--------|-------------------------|---------------------------|
| Derivatives | Autodiff through network | Exact from coefficients |
| Interpretability | Black box | Coefficients have meaning |
| Extrapolation | Poor beyond training | Polynomial extrapolation |
| Memory | Higher (compute graph) | Lower |

---

## Example

For ODE: `u'' - 5u' + 6u = 0` with `u(0) = 4, u'(0) = 2`

True power series coefficients:
```
a₀ = 4.0    (= u(0))
a₁ = 2.0    (= u'(0))
a₂ = 1.0    (computed from ODE)
a₃ = 1.333...
...
```

Neural network learns to output these coefficients.

---

*See also: [ODE Representation](../concepts/ode-representation.md), [Loss Components](../concepts/loss-components.md)*
