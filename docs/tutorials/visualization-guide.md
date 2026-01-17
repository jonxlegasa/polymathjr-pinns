# Tutorial: Visualization Guide

Using the Python dashboard to analyze PINN results.

---

## Overview

This tutorial covers:
1. Installing Python dependencies
2. Loading training outputs
3. Using interactive features
4. Exporting plots

---

## Setup

### Install Dependencies

```bash
cd scripts
python -m venv .venv
source .venv/bin/activate  # Linux/macOS
pip install numpy matplotlib
```

### Verify Installation

```bash
python -c "import matplotlib; print('Ready!')"
```

---

## Loading Data

### From Training Output

```python
import json
import pandas as pd
from visualizer import PowerSeriesVisualizer

# Load predicted coefficients
with open('../data/training-run-1/coefficients.json') as f:
    predicted = json.load(f)

# Convert keys to integers
predicted = {int(k): v for k, v in predicted.items()}

# Load true coefficients (from benchmark)
with open('../data/benchmark_dataset.json') as f:
    benchmark = json.load(f)
    true_coeffs = list(benchmark["01"].values())[0]

# Load loss data (optional)
df = pd.read_csv('../data/training-run-1/batch-01/iteration_output.csv')
loss_data = {50: df.loc[df['loss_type'] == 'total_loss'].values[0][1:].tolist()}
```

---

## Creating Visualizer

### Basic Usage

```python
viz = PowerSeriesVisualizer(
    predicted_coeffs=predicted,
    true_coeffs=true_coeffs
)
viz.show()
```

### With Loss Curves

```python
viz = PowerSeriesVisualizer(
    predicted_coeffs=predicted,
    true_coeffs=true_coeffs,
    loss_data=loss_data,
    neuron_counts=[10, 50, 100]
)
viz.show()
```

### Custom X Range

```python
viz = PowerSeriesVisualizer(
    predicted_coeffs=predicted,
    true_coeffs=true_coeffs,
    x_range=(0, 2),      # Extended domain
    num_points=200       # More points for smoothness
)
viz.show()
```

---

## Interactive Features

### Neuron Count Slider

- **Location:** Bottom of figure
- **Function:** Switch between predictions from different network sizes
- **Updates:** All plots automatically

### Reset Button

- **Location:** Bottom right
- **Function:** Returns slider to initial value

---

## Understanding Plots

### 1. Solution Comparison

**Left plot:** Shows analytical vs PINN solution over domain

- **Blue line:** Analytical (true) solution
- **Orange dashed:** PINN approximation
- **Good fit:** Lines overlap

### 2. Coefficient Comparison

**Bar chart:** True vs predicted coefficients

- **Blue bars:** True coefficients
- **Orange bars:** PINN predictions
- **Check:** First coefficients (a₀, a₁) should match well

### 3. Coefficient Error (Log Scale)

**Semilogy plot:** Absolute error per coefficient

- **Good:** Errors < 0.01 for early coefficients
- **Expected:** Error grows for higher indices

### 4. Solution Error (Log Scale)

**Semilogy plot:** Point-wise solution error over domain

- **Good:** Consistently low error
- **Watch for:** Error growth at domain boundaries

### 5. Loss Curve (if provided)

**Semilogy plot:** Training loss over iterations

- **Good:** Monotonic decrease
- **Final value:** Should be < 0.01

---

## Exporting Plots

### Save Current View

```python
# After viz.show(), use matplotlib toolbar
# Or programmatically:
import matplotlib.pyplot as plt

viz = PowerSeriesVisualizer(...)
# Don't call show() yet

plt.savefig('my_analysis.png', dpi=300, bbox_inches='tight')
plt.show()
```

### Save Individual Subplots

```python
fig, axes = plt.subplots(2, 2, figsize=(12, 10))

# Plot solution
axes[0,0].plot(x, true_solution, label='Analytical')
axes[0,0].plot(x, pinn_solution, '--', label='PINN')
axes[0,0].legend()
axes[0,0].set_title('Solution Comparison')

# ... configure other axes

plt.savefig('custom_analysis.png')
```

---

## Troubleshooting

### No Display

```python
# Try different backend
import matplotlib
matplotlib.use('TkAgg')  # or 'Qt5Agg'
import matplotlib.pyplot as plt
```

### Slow Rendering

```python
# Reduce points
viz = PowerSeriesVisualizer(
    ...,
    num_points=50  # Instead of 100
)
```

### Memory Issues

```python
# Close figures after saving
plt.close('all')
```

---

*See also: [visualizer.py](../python-modules/visualizer.md), [main.py Examples](../python-modules/main-examples.md)*
