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
Input: [ODE coefficients, initial conditions]
    ↓
Dense(input → neurons, activation) x 6 hidden layers
    ↓
Dense(neurons → output_size)
    ↓
Output: power series coefficients
```

---

## Training Pipeline

1. **Initialize** network with random parameters
2. **Adam** optimization (10,000 iterations)
3. **LBFGS** fine-tuning (100 iterations)
4. **Evaluate** on benchmark dataset
5. **Save** plots and loss history

---

*See also: [Data Flow](data-flow.md), [PINN.jl](../julia-modules/pinn.md)*
