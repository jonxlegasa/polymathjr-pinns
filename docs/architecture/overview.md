# System Overview

## Architecture Diagram

```
┌──────────────────────────────────────────────────────────────┐
│                     main.jl (Orchestrator)                    │
└───────────────┬─────────────────────┬────────────────────────┘
                │                     │
    ┌───────────▼───────────┐   ┌─────▼─────────────────┐
    │   plugboard.jl        │   │      PINN.jl          │
    │   (Dataset Gen)       │   │   (Core Training)     │
    └───────────┬───────────┘   └─────────┬─────────────┘
                │                         │
                ▼                         ▼
    ┌───────────────────────┐   ┌─────────────────────────┐
    │  training_dataset.json│   │  data/training-run-N/   │
    └───────────────────────┘   └──────────┬──────────────┘
                                           │
                                ┌──────────▼──────────┐
                                │   visualizer.py     │
                                └─────────────────────┘
```

---

## Neural Network Architecture

```
Input: [α matrix, initial conditions]
    ↓
Dense(input → neurons, σ)
    ↓
Dense(neurons → neurons, σ) × 6
    ↓
Dense(neurons → N+1)
    ↓
Output: [a₀, a₁, ..., aₙ] (power series coefficients)
```

---

## Loss Function

```
Total Loss = pde_weight × L_pde + bc_weight × L_bc + sup_weight × L_supervised

L_pde = Mean squared ODE residual at collocation points
L_bc  = |u(x₀) - IC₁| + |u'(x₀) - IC₂|
L_sup = MSE(predicted coefficients, true coefficients)
```

---

## Training Pipeline

1. **Initialize** network with random parameters
2. **Adam** optimization (10,000 iterations)
3. **LBFGS** fine-tuning (100 iterations)
4. **Evaluate** on benchmark dataset
5. **Save** plots and loss history

---

*See also: [PINN Theory](pinn-theory.md), [Power Series Approach](power-series-approach.md)*
