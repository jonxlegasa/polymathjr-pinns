module loss_functions
using CSV
using DataFrames

include("./helper_funcs.jl")
using .helper_funcs

struct LossFunctionSettings
  a_vec::Vector{Float32}
  n_terms_for_power_series::Int
  ode_matrix_flat::Vector{Float32}
  x_left::Float32
  boundary_condition::Array{Float32}
  xs::Vector{Float32}
  num_points::Int
  num_supervised::Int
  data::Vector{Float32}
end

fact = factorial.(big.(0:21)) # I AM putting this term after the PINN guesses the coefficients without the factorial term

function ode_residual(settings::LossFunctionSettings, x)
  return sum(
    settings.ode_matrix_flat[order+1] * (
      order == 0 ?
      sum(settings.a_vec[i] * x^(i - 1) / fact[i] for i in 1:settings.n_terms_for_power_series+1) :
      sum(
        settings.a_vec[i] * x^(i - 1 - order) / fact[i-order]
        for i in (order+1):(settings.n_terms_for_power_series+1)
      )
    )
    for order in 0:(length(settings.ode_matrix_flat)-1)
  )
end

# Updated functions using the settings struct
function generate_u_approx(settings::LossFunctionSettings)
  u_approx(x) = sum(settings.a_vec[i] * x^(i - 1) / fact[i] for i in 1:(settings.n_terms_for_power_series+1))
  return u_approx
end

function generate_loss_pde_value(settings::LossFunctionSettings)
  loss_pde = sum(
    abs2,
    ode_residual(settings, xi)
    for xi in settings.xs
  ) / settings.num_points

  return loss_pde
end

#=
function generate_loss_bc_value(settings::LossFunctionSettings)
  u_approx = generate_u_approx(settings)
  loss_bc = abs2(u_approx(settings.x_left) - settings.boundary_condition[1])
  return loss_bc
end
=#

function generate_loss_bc_value(settings::LossFunctionSettings)
  # Define the approximate solution and its derivatives using the coefficients from the network.
  # This is the power series representation: u(x) = Σ aᵢ * x^(i-1) / (i-1)!
  u_approx(x) = sum(settings.a_vec[i] * x^(i - 1) / fact[i] for i in 1:settings.n_terms_for_power_series+1)
  Du_approx(x) = sum(settings.a_vec[i] * x^(i - 2) / fact[i-1] for i in 2:settings.n_terms_for_power_series+1) # First derivative
  # D3u_approx(x) = sum(a_vec[i] * x^(i - 4) / fact[i-3] for i in 4:N+1) # Third derivative

  # Boundary condition loss
  loss_bc = abs(u_approx(settings.x_left) - settings.boundary_condition[1]) + abs(Du_approx(settings.x_left) - settings.boundary_condition[2])

  # Boundary condition loss for first order
  # loss_bc = abs(u_approx(settings.x_left) - settings.boundary_condition[1])

  return loss_bc
end

#=
function generate_loss_supervised_value(settings::LossFunctionSettings)
  # Take absolute values first (since log requires positive numbers)
  # Add small epsilon to avoid log(0)
  log_predicted = log.(abs.(settings.a_vec[1:settings.num_supervised]) .+ 1e-10)
  log_target = log.(abs.(settings.data) .+ 1e-10)

  # Standard squared error in log-space
  loss_supervised = sum(abs2, log_predicted - log_target) / settings.num_supervised
  return loss_supervised
end
=#

# first, we are going to try this approach for now.
function generate_loss_supervised_value(settings::LossFunctionSettings)
  # println("PINNs output: ", settings.a_vec)
  # println("REAL coefficients: ", settings.data)
  loss_supervised = sum(abs2, settings.a_vec[1:settings.num_supervised] - settings.data) / settings.num_supervised

  return loss_supervised
end

export LossFunctionSettings, generate_loss_pde_value, generate_loss_bc_value, generate_loss_supervised_value, ode_residual, generate_u_approx

end
