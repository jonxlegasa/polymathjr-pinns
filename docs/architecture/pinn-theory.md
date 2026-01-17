# PINN Theory

## What are Physics-Informed Neural Networks?

PINNs embed physical laws (differential equations) directly into the neural network's loss function. Instead of relying purely on data, PINNs enforce that the learned solution satisfies the governing equations.

---

## Standard PINN Approach

For an ODE: `L[u] = 0` with boundary conditions `B[u] = g`

**Loss function:**
```
L_total = L_physics + L_boundary + L_data

L_physics = ||L[u_NN]||²     (ODE residual)
L_boundary = ||B[u_NN] - g||²  (boundary conditions)
L_data = ||u_NN - u_data||²   (optional supervised data)
```

---

## Our Approach: Power Series Coefficients

Instead of learning `u(x)` directly, our network learns the coefficients of a truncated power series:

```
u(x) = Σ(i=0 to N) aᵢ · xⁱ / i!
```

The neural network outputs: `[a₀, a₁, a₂, ..., aₙ]`

**Advantages:**
- Derivatives are computed exactly from coefficients
- No automatic differentiation through the network for derivatives
- Coefficients have physical meaning (initial conditions, rates of change)

---

## ODE Residual

For ODE: `Σ(k=0 to m) αₖ · u^(k)(x) = 0`

The k-th derivative of the power series:
```
u^(k)(x) = Σ(i=k to N) aᵢ · xⁱ⁻ᵏ / (i-k)!
```

Residual at collocation point x:
```
R(x) = Σ(k) αₖ · u^(k)(x)
```

PDE Loss = mean of R(x)² over collocation points

---

## References

- Raissi, M., Perdikaris, P., & Karniadakis, G. E. (2019). Physics-informed neural networks.
- Baydin, A. G., et al. (2018). Automatic differentiation in machine learning: a survey.

---

*See also: [Power Series Approach](power-series-approach.md), [Loss Components](../concepts/loss-components.md)*
