# main.jl

Entry point for training runs.

**Location:** `src/main.jl`

---

## Functions

### `create_training_run_dirs(run_number, batch_size)`

Creates output directory structure for a training run.

```julia
create_training_run_dirs(run_number::Int64, batch_size::Any)
```

**Creates:**
```
data/training-run-{run_number}/
├── batch-01/
├── batch-02/
└── ...
```

---

### `init_batches(batch_sizes)`

Initializes and generates ODE datasets for each batch size.

```julia
init_batches(batch_sizes::Array{Int})
```

Uses `plugboard.jl` to generate random ODEs with analytical solutions.

---

### `run_training_sequence(batch_sizes)`

Main orchestration function.

```julia
run_training_sequence(batch_sizes::Array{Int})
```

**Steps:**
1. Initialize batches (dataset generation)
2. Create `PINNSettings` for each batch
3. Call `train_pinn()` for training
4. Call `evaluate_solution()` for benchmarking

---

## Configuration

```julia
batch = [10]  # Array of batch sizes to train on
```

---

*See also: [PINN.jl](pinn.md), [plugboard.jl](plugboard.md)*
