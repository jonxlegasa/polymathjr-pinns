# visualizer.py

Interactive visualization dashboard for PINN results.

**Location:** `scripts/visualizer.py`

---

## Classes

### PlotConfig (dataclass)

Configuration for individual plots.

```python
@dataclass
class PlotConfig:
    data_key: str              # Key to retrieve data
    title: str
    xlabel: str
    ylabel: str
    plot_type: str = 'line'    # 'line', 'scatter', 'semilogy'
    colors: Optional[List[str]] = None
    linestyles: Optional[List[str]] = None
    labels: Optional[List[str]] = None
    grid: bool = True
```

---

### SliderConfig (dataclass)

Configuration for interactive sliders.

```python
@dataclass
class SliderConfig:
    name: str                  # Identifier
    label: str                 # Display label
    valmin: float
    valmax: float
    valinit: float             # Initial value
    valstep: Optional[float] = 1
    position: Tuple[float, float, float, float]
```

---

### GeneralizedVisualizer

Multi-plot interactive framework.

```python
GeneralizedVisualizer(
    data_dict: Dict,
    plot_configs: List[PlotConfig],
    slider_configs: List[SliderConfig],
    layout: Tuple[int, int],      # (rows, cols)
    figsize: Tuple[int, int],
    main_title: str
)
```

**Methods:**

| Method | Description |
|--------|-------------|
| `_setup_plot(ax, config, idx)` | Configure subplot |
| `_update_plot(ax, config, idx)` | Update plot data |
| `_plot_lines(ax, data, config, idx)` | Line plotting |
| `_plot_semilogy(ax, data, config, idx)` | Log-scale plot |
| `_plot_scatter(ax, data, config, idx)` | Scatter plot |
| `_create_sliders()` | Create widgets |
| `_on_slider_change(name, val)` | Slider callback |
| `show()` | Display dashboard |

---

### PowerSeriesVisualizer

Specialized for PINN power series analysis. Extends `GeneralizedVisualizer`.

```python
PowerSeriesVisualizer(
    predicted_coeffs: Dict[int, List[float]],  # {neurons: coeffs}
    true_coeffs: List[float],
    x_range: Tuple[float, float] = (0, 1),
    num_points: int = 100,
    loss_data: Optional[Dict] = None,
    neuron_counts: Optional[List[int]] = None
)
```

**Generated Plots:**
1. ODE Solution Comparison (Analytic vs PINN)
2. Coefficient Comparison (True vs Predicted)
3. Coefficient Error (log scale)
4. Solution Error (log scale)
5. Loss vs Iteration (if loss data provided)

---

## Usage Example

```python
from visualizer import PowerSeriesVisualizer

# Predicted coefficients for different neuron counts
predicted = {
    10: [4.0, 1.9, 0.95, ...],
    50: [4.0, 2.0, 1.0, ...],
    100: [4.0, 2.0, 1.0, ...]
}

# True coefficients
true_coeffs = [4.0, 2.0, 1.0, 1.333, ...]

# Loss history (optional)
loss_data = {
    10: [0.9, 0.5, 0.2, ...],
    50: [0.8, 0.3, 0.1, ...]
}

viz = PowerSeriesVisualizer(
    predicted_coeffs=predicted,
    true_coeffs=true_coeffs,
    loss_data=loss_data,
    neuron_counts=[10, 50, 100]
)
viz.show()
```

---

## Features

- **Interactive sliders:** Adjust neuron count, view different runs
- **Reset button:** Return to initial state
- **Multiple layouts:** 1x2, 2x2, 2x3, 3x3
- **Plot types:** Line, scatter, semilogy
- **Backend detection:** Qt5Agg, TkAgg, GTK3Agg, WXAgg

---

*See also: [main.py Examples](main-examples.md), [Visualization Tutorial](../tutorials/visualization-guide.md)*
