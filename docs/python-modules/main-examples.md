# main.py Examples

Example usage of the Python visualization tools.

**Location:** `scripts/main.py`

---

## Functions

### `setup_backend()`

Configures matplotlib backend.

```python
def setup_backend():
    # Tries: Qt5Agg, TkAgg, GTK3Agg, WXAgg
    # Falls back to default if none available
```

---

### `example_with_loss()`

Demonstrates visualization with synthetic data.

```python
def example_with_loss():
    # Create example coefficients
    true_coeffs = [4.0, 2.0, 1.0, 1.333, ...]

    predicted = {
        10: [noisy coefficients],
        50: [better coefficients],
        100: [best coefficients]
    }

    # Create loss data
    loss_data = {
        10: [decreasing losses],
        50: [faster convergence]
    }

    # Visualize
    viz = PowerSeriesVisualizer(
        predicted_coeffs=predicted,
        true_coeffs=true_coeffs,
        loss_data=loss_data
    )
    viz.show()
```

---

### `example_with_real_data()`

Template for loading actual training outputs.

```python
def example_with_real_data():
    # Load coefficients from JSON
    with open('coefficients.json') as f:
        predicted = json.load(f)

    # Load loss from CSV
    loss_df = pd.read_csv('iteration_output.csv')

    # Convert and visualize
    viz = PowerSeriesVisualizer(
        predicted_coeffs=predicted,
        true_coeffs=benchmark_coeffs,
        loss_data=loss_dict
    )
    viz.show()
```

---

## Running Examples

```bash
cd scripts
source .venv/bin/activate
python main.py
```

---

## Expected Output

Interactive matplotlib window with:
- Solution comparison (analytic vs PINN)
- Coefficient bar chart
- Error plots (log scale)
- Loss curves
- Neuron count slider

---

*See also: [visualizer.py](visualizer.md)*
