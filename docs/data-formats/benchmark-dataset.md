# Benchmark Dataset Format

Reference ODE for model evaluation.

**Location:** `data/benchmark_dataset.json`

---

## Structure

Same format as training dataset:

```json
{
  "01": {
    "[1; 6; 2;;]": [1.0, 4.0, -12.5, 73.0, ...]
  }
}
```

---

## Purpose

- Consistent evaluation across training runs
- Compare different hyperparameter configurations
- Measure generalization (ODE not in training set)

---

## Default Benchmark

**ODE:** Defined by α matrix in the JSON file

**Properties:**
- Satisfies real roots constraint (`a² - 4b > 0`)
- Has known analytical solution
- Provides challenging but solvable test case

---

## Usage

```julia
# In PINN.jl
benchmark = JSON.parsefile("data/benchmark_dataset.json")
evaluate_solution(settings, p_trained, net, st, benchmark, output_dir)
```

---

## Modifying the Benchmark

To change the benchmark ODE:

1. Choose new ODE with known solution
2. Compute power series coefficients
3. Update `benchmark_dataset.json`

```julia
# Example: u'' - 2u' + u = 0, u(0) = 1, u'(0) = 1
α = [1; -2; 1;;]
IC = [1.0, 1.0]
coeffs = solve_ode_series_closed_form(α, IC, 20)
```

---

## Best Practices

- Keep benchmark separate from training data
- Use same benchmark across experiments for comparison
- Document benchmark ODE in experiment notes

---

*See also: [Training Dataset](training-dataset.md), [evaluate_solution()](../julia-modules/pinn.md)*
