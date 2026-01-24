# helper_funcs.jl

Utility functions for data conversion and loss logging.

**Location:** `utils/helper_funcs.jl`

---

## Loss Buffer

In-memory buffer for accumulating loss values during training.

### `initialize_loss_buffer()`

Initializes/resets the loss buffer.

### `buffer_loss_values(; kwargs...)`

Adds loss values to buffer.

```julia
buffer_loss_values(total=0.5, pde=0.3, bc=0.1, supervised=0.1)
```

### `write_buffer_to_csv(csv_file)`

Writes buffered losses to CSV file.

### `get_buffer_size()`

Returns number of buffered entries.

---

## Data Conversion

### `convert_plugboard_keys(inner_dict)`

Converts JSON string keys back to Julia matrices.

```julia
convert_plugboard_keys(dict) → Dict
```

---

## Math Utilities

### `quadratic_formula(a, b, c)`

Solves quadratic equations. Used for computing analytical ODE solutions.

```julia
quadratic_formula(a, b, c) → (root1, root2)
```

---

### `generate_valid_matrix()`

Generates random 3x1 matrix satisfying the real roots constraint.

### `create_matrix_array(n)`

Creates array of n random valid matrices.

```julia
create_matrix_array(n::Int) → Vector{Matrix}
```

---

*See also: [plugboard.jl](plugboard.md), [Output CSV](../data-formats/output-csv.md)*
