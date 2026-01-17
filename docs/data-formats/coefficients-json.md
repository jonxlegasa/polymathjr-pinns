# Coefficients JSON Format

Format for storing predicted coefficients for visualization.

---

## Structure

```json
{
  "10": [4.0, 1.95, 0.98, 1.30, ...],
  "20": [4.0, 1.99, 1.00, 1.32, ...],
  "50": [4.0, 2.00, 1.00, 1.33, ...],
  "100": [4.0, 2.00, 1.00, 1.33, ...]
}
```

---

## Schema

| Key | Value |
|-----|-------|
| Neuron count (string) | Array of predicted coefficients |

---

## Purpose

Used by Python visualizer to:
- Compare predictions across network sizes
- Enable slider-based exploration
- Generate comparison plots

---

## Creating from Training Output

After running training with different neuron counts:

```julia
# Pseudo-code
results = Dict()
for neurons in [10, 20, 50, 100]
    settings = PINNSettings(neuron_num=neurons, ...)
    p_trained, net, st = train_pinn(settings, csv)
    coeffs = predict_coefficients(net, p_trained, st, input)
    results[string(neurons)] = coeffs
end
JSON.write("coefficients.json", results)
```

---

## Loading in Python

```python
import json

with open('coefficients.json', 'r') as f:
    predicted = json.load(f)

# Convert keys to integers if needed
predicted = {int(k): v for k, v in predicted.items()}
```

---

## Integration with Visualizer

```python
from visualizer import PowerSeriesVisualizer

viz = PowerSeriesVisualizer(
    predicted_coeffs=predicted,
    true_coeffs=benchmark_coeffs,
    neuron_counts=[10, 20, 50, 100]
)
viz.show()
```

---

*See also: [visualizer.py](../python-modules/visualizer.md), [Scaling Experiments](../tutorials/scaling-experiments.md)*
