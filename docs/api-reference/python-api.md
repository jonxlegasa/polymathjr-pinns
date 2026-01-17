# Python API Reference

Complete class and function signatures for Python modules.

---

## visualizer.py

### Dataclasses

```python
@dataclass
class PlotConfig:
    data_key: str
    title: str
    xlabel: str
    ylabel: str
    plot_type: str = 'line'  # 'line', 'scatter', 'semilogy'
    colors: Optional[List[str]] = None
    linestyles: Optional[List[str]] = None
    labels: Optional[List[str]] = None
    grid: bool = True
```

```python
@dataclass
class SliderConfig:
    name: str
    label: str
    valmin: float
    valmax: float
    valinit: float
    valstep: Optional[float] = 1
    position: Tuple[float, float, float, float]
```

---

### GeneralizedVisualizer

```python
class GeneralizedVisualizer:
    def __init__(
        self,
        data_dict: Dict[str, Any],
        plot_configs: List[PlotConfig],
        slider_configs: List[SliderConfig],
        layout: Tuple[int, int] = (1, 1),
        figsize: Tuple[int, int] = (12, 8),
        main_title: str = ""
    )
```

**Methods:**

```python
def _setup_plot(self, ax: Axes, config: PlotConfig, plot_idx: int) → None
```
Configures individual subplot.

```python
def _update_plot(self, ax: Axes, config: PlotConfig, plot_idx: int) → None
```
Updates plot with current data.

```python
def _plot_lines(self, ax: Axes, data: Any, config: PlotConfig, plot_idx: int) → None
```
Line plotting implementation.

```python
def _plot_semilogy(self, ax: Axes, data: Any, config: PlotConfig, plot_idx: int) → None
```
Logarithmic scale plotting.

```python
def _plot_scatter(self, ax: Axes, data: Any, config: PlotConfig, plot_idx: int) → None
```
Scatter plot implementation.

```python
def _get_plot_data(self, data_key: str) → Any
```
Retrieves data for plotting.

```python
def _create_sliders(self) → None
```
Creates interactive slider widgets.

```python
def _on_slider_change(self, slider_name: str, value: float) → None
```
Handles slider value changes.

```python
def _create_reset_button(self) → None
```
Creates reset button widget.

```python
def show(self) → None
```
Displays the interactive visualization.

---

### PowerSeriesVisualizer

```python
class PowerSeriesVisualizer(GeneralizedVisualizer):
    def __init__(
        self,
        predicted_coeffs: Dict[int, List[float]],
        true_coeffs: List[float],
        x_range: Tuple[float, float] = (0, 1),
        num_points: int = 100,
        loss_data: Optional[Dict[int, List[float]]] = None,
        neuron_counts: Optional[List[int]] = None
    )
```

**Additional Methods:**

```python
def _prepare_data(
    self,
    predicted_coeffs: Dict[int, List[float]],
    true_coeffs: List[float],
    x_data: np.ndarray,
    loss_data: Optional[Dict],
    neuron_counts: List[int]
) → Dict
```
Prepares data dictionary for visualization.

```python
def _create_plot_configs(self, include_loss: bool) → List[PlotConfig]
```
Creates plot configurations for power series analysis.

```python
def _evaluate_power_series(self, coefficients: List[float], x: np.ndarray) → np.ndarray
```
Evaluates power series at given x values.

```python
def _get_plot_data(self, data_key: str) → Any
```
Override to handle neuron count slider.

---

## main.py

### Functions

```python
def setup_backend() → None
```
Configures matplotlib backend (Qt5Agg, TkAgg, etc.).

```python
def example_with_loss() → None
```
Demonstrates visualization with synthetic coefficient and loss data.

```python
def example_with_real_data() → None
```
Template for loading and visualizing real training outputs.

---

## Usage Examples

### Basic Visualization

```python
from visualizer import PowerSeriesVisualizer

viz = PowerSeriesVisualizer(
    predicted_coeffs={50: [4.0, 2.0, 1.0, ...]},
    true_coeffs=[4.0, 2.0, 1.0, ...]
)
viz.show()
```

### With Loss Data

```python
viz = PowerSeriesVisualizer(
    predicted_coeffs={10: [...], 50: [...], 100: [...]},
    true_coeffs=[...],
    loss_data={10: [...], 50: [...], 100: [...]},
    neuron_counts=[10, 50, 100]
)
viz.show()
```

### Custom Visualizer

```python
from visualizer import GeneralizedVisualizer, PlotConfig, SliderConfig

configs = [
    PlotConfig("data1", "Title 1", "X", "Y", plot_type='line'),
    PlotConfig("data2", "Title 2", "X", "Y", plot_type='semilogy')
]

sliders = [
    SliderConfig("param", "Parameter", 0, 100, 50, position=[0.2, 0.02, 0.6, 0.03])
]

viz = GeneralizedVisualizer(
    data_dict=my_data,
    plot_configs=configs,
    slider_configs=sliders,
    layout=(1, 2)
)
viz.show()
```

---

*See also: [Julia API](julia-api.md)*
