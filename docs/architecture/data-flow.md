# Data Flow

## Complete Pipeline

```
1. ODE Definition
   ┌─────────────────────────────────────┐
   │ ODE coefficient matrix              │
   │ Initial conditions array            │
   └──────────────────┬──────────────────┘
                      │
                      ▼ plugboard.jl
2. Analytical Solution
   ┌─────────────────────────────────────┐
   │ solve_ode_series_closed_form()      │
   │ → power series coefficients         │
   └──────────────────┬──────────────────┘
                      │
                      ▼ JSON export
3. Training Dataset
   ┌─────────────────────────────────────┐
   │ training_dataset.json               │
   │ ODE matrix → coefficients mapping   │
   └──────────────────┬──────────────────┘
                      │
                      ▼ PINN.jl loads
4. Neural Network Training
   ┌─────────────────────────────────────┐
   │ Network predicts coefficients       │
   │ Loss = PDE + BC + Supervised        │
   │ Optimizer: Adam → LBFGS             │
   └──────────────────┬──────────────────┘
                      │
                      ▼
5. Output
   ┌─────────────────────────────────────┐
   │ • iteration_output.csv (losses)     │
   │ • solution_plot.png                 │
   │ • coefficient_plot.png              │
   │ • trained parameters                │
   └──────────────────┬──────────────────┘
                      │
                      ▼ visualizer.py
6. Interactive Analysis
   ┌─────────────────────────────────────┐
   │ Compare solutions & coefficients    │
   │ Slider controls for exploration     │
   └─────────────────────────────────────┘
```

---

## Input Format

**ODE coefficient matrix** (stored as string key in JSON)

**Initial conditions** (array of values for boundary conditions)

---

## Output Files

| File | Content |
|------|---------|
| `iteration_output.csv` | Loss values per iteration |
| `solution_plot.png` | Analytical vs PINN solution |
| `coefficient_plot.png` | True vs predicted coefficients |
| `error_plot.png` | Coefficient and solution errors |

---

*See also: [Training Dataset Format](../data-formats/training-dataset.md)*
