# Output CSV Format

Loss history tracking during training.

**Location:** `data/training-run-N/batch-XX/iteration_output.csv`

---

## Structure

```csv
loss_type,iter_1,iter_2,iter_3,...,iter_N
total_loss,0.9500,0.8200,0.7100,...,0.0012
total_loss_bc,0.3000,0.2500,0.1800,...,0.0001
total_loss_pde,0.5000,0.4200,0.3500,...,0.0008
total_loss_supervised,0.1500,0.1500,0.1800,...,0.0003
```

---

## Columns

| Column | Description |
|--------|-------------|
| `loss_type` | Name of loss component |
| `iter_N` | Value at iteration N |

---

## Rows

| Row | Description |
|-----|-------------|
| `total_loss` | Weighted sum of all losses |
| `total_loss_bc` | Boundary condition loss |
| `total_loss_pde` | ODE residual loss |
| `total_loss_supervised` | Supervised coefficient MSE |

---

## Reading in Julia

```julia
using CSV, DataFrames

df = CSV.read("iteration_output.csv", DataFrame)

# Get total loss values
total_loss = Vector(df[df.loss_type .== "total_loss", 2:end][1, :])
```

---

## Reading in Python

```python
import pandas as pd

df = pd.read_csv("iteration_output.csv")
df = df.set_index('loss_type')

# Get total loss values
total_loss = df.loc['total_loss'].values
```

---

## Plotting Loss Curves

```python
import matplotlib.pyplot as plt

iterations = range(1, len(total_loss) + 1)
plt.semilogy(iterations, total_loss)
plt.xlabel('Iteration')
plt.ylabel('Total Loss')
plt.title('Training Loss')
plt.show()
```

---

## Analysis

Look for:
- **Monotonic decrease:** Healthy training
- **Plateaus:** May need more iterations or learning rate adjustment
- **Oscillations:** Learning rate too high
- **Component balance:** No single loss dominating

---

*See also: [Loss Components](../concepts/loss-components.md), [helper_funcs.jl](../julia-modules/helper-funcs.md)*
