module Plugboard

using LinearAlgebra
using TaylorSeries
using Random
using JSON

struct Settings
  ode_order::Int
  poly_degree::Int
  dataset_size::Int
  data_dir::String
end

function get_user_inputs()
  println("The Plugboard: Randomized ODE Generator")
  println("=================================")
  print("What order do you want your ODE to be? (e.g., 1 for first order, 2 for second order): ")
  ode_order = parse(Int, readline())
  print("What is the highest degree polynomial you want? (e.g., 2 for degree 2): ")
  poly_degree = parse(Int, readline())
  print("How many ODEs do you want solved? (e.g., 50 for 50 training examples): ")
  dataset_size = parse(Int, readline())
  return ode_order, poly_degree, dataset_size
end




export Settings, generate_random_ode_dataset
end
