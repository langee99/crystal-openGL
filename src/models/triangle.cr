class Triangle
  @@name = "triangle"

  @@vertices = [
    # Poisitions                 # Colors
    0.5_f32, -0.5_f32, 0.0_f32,  1.0_f32, 0.0_f32, 0.0_f32, # Bottom right
   -0.5_f32, -0.5_f32, 0.0_f32,  0.0_f32, 1.0_f32, 0.0_f32, # Bottom left
    0.0_f32,  0.5_f32, 0.0_f32,  0.0_f32, 0.0_f32, 1.0_f32  # Top
  ]

  def name
    @@name
  end

  def vertices
    @@vertices
  end
end

