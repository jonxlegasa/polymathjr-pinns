# Data Flow

## Complete Pipeline

```
1. ODE Definition
   ┌─────────────────────────────────────┐
   │ α matrix: [1; -5; 6;;]              │
   │ Initial conditions: [4.0, 2.0]      │
   └──────────────────┬──────────────────┘
                      │
                      ▼ plugboard.jl
2. Analytical Solution
   ┌─────────────────────────────────────┐
   │ solve_ode_series_closed_form()      │
   │ → [a₀, a₁, a₂, ..., aₙ]            │
   └──────────────────┬──────────────────┘
                      │
                      ▼ JSON export
3. Training Dataset
   ┌─────────────────────────────────────┐
   │ training_dataset.json               │
   │ {"01": {"[1;-5;6;;]": [4,2,1,...]}} │
   └──────────────────┬──────────────────┘
                      │
                      ▼ PINN.jl loads
4. Neural Network Training
   ┌─────────────────────────────────────┐
   │ Network(α, IC) → predicted [aᵢ]    │
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

**ODE α matrix** (stored as string key):
```
"[1; -5; 6;;]" → u'' - 5u' + 6u = 0
```

**Initial conditions** (array):
```
[4.0, 2.0] → u(0) = 4, u'(0) = 2
```

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
