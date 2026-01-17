# ProgressBar.jl

Progress tracking for training visualization.

**Location:** `utils/ProgressBar.jl`

---

## ProgressBarSettings Struct

```julia
struct ProgressBarSettings
    maxiters::Int    # Total iterations
    message::String  # Display message
end
```

---

## Bar Function

### `Bar(s::ProgressBarSettings)`

Creates callback function for optimization progress.

```julia
Bar(s::ProgressBarSettings) → callback_function
```

**Usage with Optimization.jl:**
```julia
settings = ProgressBarSettings(10000, "Training PINN")
callback = Bar(settings)

solve(problem, Adam(), callback=callback)
```

---

## Display

Updates every 100 iterations showing:
- Current iteration / total
- Elapsed time
- Estimated time remaining

---

*See also: [PINN.jl](pinn.md)*
