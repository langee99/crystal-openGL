class Rectangle
  @@vertices = [ 0.5_f32,  0.5_f32, 0.0_f32, # Top right
                 0.5_f32, -0.5_f32, 0.0_f32, # Bottom right
                -0.5_f32, -0.5_f32, 0.0_f32, # Bottom Left
                -0.5_f32,  0.5_f32, 0.0_f32] # Top left

  @@indices = [
    0_u32, 1_u32, 3_u32,  # First triangle
    1_u32, 2_u32, 3_u32   # Second triangle
  ]

  def vertices
    @@vertices
  end

  def indices
    @@indices
  end
end
