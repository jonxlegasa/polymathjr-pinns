module helper_funcs

using CSV
using DataFrames

function convert_plugboard_keys(inner_dict)
  converted_dict = Dict{Matrix{Int},Any}()
  for (alpha_matrix_key, series_coeffs) in inner_dict
    # println("The current  ODE I am calculating the loss for right now: ", alpha_matrix_key)
    # println("The local loss is locally lossing...")
    alpha_matrix = eval(Meta.parse(alpha_matrix_key)) # convert from string to matrix 
    converted_dict[alpha_matrix] = series_coeffs
  end

  return converted_dict
end

const loss_buffer = Ref{Vector{Dict{Symbol,Float64}}}(Dict{Symbol,Float64}[])

"""
Initialize the loss buffer at the start of training
"""
function initialize_loss_buffer()
  loss_buffer[] = Dict{Symbol,Float64}[]
  println("Loss buffer initialized")
end

"""
Add loss values to the in-memory buffer (very fast)
"""
function buffer_loss_values(; kwargs...)
  loss_dict = Dict{Symbol,Float64}()
  for (key, value) in kwargs
    loss_dict[key] = Float64(value)
  end
  push!(loss_buffer[], loss_dict)
end

"""
Write all buffered loss values to CSV file at once
"""
function write_buffer_to_csv(csv_file)
  # Create directory if needed
  dir = dirname(csv_file)
  if !isdir(dir)
    mkpath(dir)
  end

  # Initialize DataFrame with loss_type column
  df = DataFrame(loss_type=String[])

  # Process each buffered entry
  for (i, loss_dict) in enumerate(loss_buffer[])
    col_name = "iter_$(i)"

    # Add new column for this iteration
    df[!, col_name] = Vector{Union{Missing,Float64}}(missing, nrow(df))

    # Fill in loss values for this iteration
    for (key, value) in loss_dict
      loss_name = String(key)

      # Find if this loss type already exists as a row
      row_idx = findfirst(df.loss_type .== loss_name)

      if isnothing(row_idx)
        # New loss type - create new row
        new_row = DataFrame(loss_type=[loss_name])

        # Fill previous iterations with missing
        for existing_col in names(df)[2:end]  # Skip loss_type column
          if existing_col != col_name
            new_row[!, existing_col] = [missing]
          end
        end

        # Add current value
        new_row[!, col_name] = [Float64(value)]
        append!(df, new_row, promote=true)
      else
        # Existing loss type - update the cell
        df[row_idx, col_name] = Float64(value)
      end
    end
  end

  # Write to CSV once
  CSV.write(csv_file, df)
  println("Wrote $(length(loss_buffer[])) evaluations to $(csv_file)")
end

"""
Get the number of buffered evaluations
"""
function get_buffer_size()
  return length(loss_buffer[])
end

export convert_plugboard_keys, initialize_loss_buffer, buffer_loss_values, write_buffer_to_csv, get_buffer_size

end
