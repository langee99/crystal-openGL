class Cube
  @@name = "cube_tex"

  @@vertices = [
    -1.0_f32, -1.0_f32, -1.0_f32, # Face 1
		-1.0_f32, -1.0_f32,  1.0_f32,
    -1.0_f32,  1.0_f32,  1.0_f32,

		 1.0_f32,  1.0_f32, -1.0_f32,
		-1.0_f32, -1.0_f32, -1.0_f32,
    -1.0_f32,  1.0_f32, -1.0_f32,

		 1.0_f32, -1.0_f32,  1.0_f32, # Face 2
		-1.0_f32, -1.0_f32, -1.0_f32,
     1.0_f32, -1.0_f32, -1.0_f32,

		 1.0_f32,  1.0_f32, -1.0_f32,
		 1.0_f32, -1.0_f32, -1.0_f32,
    -1.0_f32, -1.0_f32, -1.0_f32,

		-1.0_f32, -1.0_f32, -1.0_f32, # Face 3
		-1.0_f32,  1.0_f32,  1.0_f32,
    -1.0_f32,  1.0_f32, -1.0_f32,

		 1.0_f32, -1.0_f32,  1.0_f32,
		-1.0_f32, -1.0_f32,  1.0_f32,
    -1.0_f32, -1.0_f32, -1.0_f32,

		-1.0_f32,  1.0_f32,  1.0_f32, # Face 4
		-1.0_f32, -1.0_f32,  1.0_f32,
     1.0_f32, -1.0_f32,  1.0_f32,

		 1.0_f32,  1.0_f32,  1.0_f32,
		 1.0_f32, -1.0_f32, -1.0_f32,
     1.0_f32,  1.0_f32, -1.0_f32,

		 1.0_f32, -1.0_f32, -1.0_f32, # Face 5
		 1.0_f32,  1.0_f32,  1.0_f32,
     1.0_f32, -1.0_f32,  1.0_f32,

		 1.0_f32,  1.0_f32,  1.0_f32,
		 1.0_f32,  1.0_f32, -1.0_f32,
    -1.0_f32,  1.0_f32, -1.0_f32,

		 1.0_f32,  1.0_f32,  1.0_f32, # Face 6
		-1.0_f32,  1.0_f32, -1.0_f32,
    -1.0_f32,  1.0_f32,  1.0_f32,

		 1.0_f32,  1.0_f32,  1.0_f32,
		-1.0_f32,  1.0_f32,  1.0_f32,
		 1.0_f32, -1.0_f32,  1.0_f32
   ]

  @@uv = [
    0.000059_f32, 1.0_f32 - 0.000004_f32, # Face 1
		0.000103_f32, 1.0_f32 - 0.336048_f32,
    0.335973_f32, 1.0_f32 - 0.335903_f32,

		1.000023_f32, 1.0_f32 - 0.000013_f32,
		0.667979_f32, 1.0_f32 - 0.335851_f32,
    0.999958_f32, 1.0_f32 - 0.336064_f32,

		0.667979_f32, 1.0_f32 - 0.335851_f32, # Face 2
		0.336024_f32, 1.0_f32 - 0.671877_f32,
    0.667969_f32, 1.0_f32 - 0.671889_f32,

		1.000023_f32, 1.0_f32 - 0.000013_f32,
		0.668104_f32, 1.0_f32 - 0.000013_f32,
    0.667979_f32, 1.0_f32 - 0.335851_f32,

		0.000059_f32, 1.0_f32 - 0.000004_f32, # Face 3
		0.335973_f32, 1.0_f32 - 0.335903_f32,
    0.336098_f32, 1.0_f32 - 0.000071_f32,

		0.667979_f32, 1.0_f32 - 0.335851_f32,
		0.335973_f32, 1.0_f32 - 0.335903_f32,
    0.336024_f32, 1.0_f32 - 0.671877_f32,

		1.000004_f32, 1.0_f32 - 0.671847_f32, # Face 4
		0.999958_f32, 1.0_f32 - 0.336064_f32,
    0.667979_f32, 1.0_f32 - 0.335851_f32,

		0.668104_f32, 1.0_f32 - 0.000013_f32,
		0.335973_f32, 1.0_f32 - 0.335903_f32,
    0.667979_f32, 1.0_f32 - 0.335851_f32,

		0.335973_f32, 1.0_f32 - 0.335903_f32, # Face 5
		0.668104_f32, 1.0_f32 - 0.000013_f32,
    0.336098_f32, 1.0_f32 - 0.000071_f32,

		0.000103_f32, 1.0_f32 - 0.336048_f32,
		0.000004_f32, 1.0_f32 - 0.671870_f32,
    0.336024_f32, 1.0_f32 - 0.671877_f32,

		0.000103_f32, 1.0_f32 - 0.336048_f32, # Face 6
		0.336024_f32, 1.0_f32 - 0.671877_f32,
    0.335973_f32, 1.0_f32 - 0.335903_f32,

		0.667969_f32, 1.0_f32 - 0.671889_f32,
		1.000004_f32, 1.0_f32 - 0.671847_f32,
		0.667979_f32, 1.0_f32 - 0.335851_f32
  ]

  @@colors = [
    0.583_f32,  0.771_f32,  0.014_f32,
    0.609_f32,  0.115_f32,  0.436_f32,
    0.327_f32,  0.483_f32,  0.844_f32,

    0.822_f32,  0.569_f32,  0.201_f32,
    0.435_f32,  0.602_f32,  0.223_f32,
    0.310_f32,  0.747_f32,  0.185_f32,

    0.597_f32,  0.770_f32,  0.761_f32,
    0.559_f32,  0.436_f32,  0.730_f32,
    0.359_f32,  0.583_f32,  0.152_f32,

    0.483_f32,  0.596_f32,  0.789_f32,
    0.559_f32,  0.861_f32,  0.639_f32,
    0.195_f32,  0.548_f32,  0.859_f32,

    0.014_f32,  0.184_f32,  0.576_f32,
    0.771_f32,  0.328_f32,  0.970_f32,
    0.406_f32,  0.615_f32,  0.116_f32,

    0.676_f32,  0.977_f32,  0.133_f32,
    0.971_f32,  0.572_f32,  0.833_f32,
    0.140_f32,  0.616_f32,  0.489_f32,

    0.997_f32,  0.513_f32,  0.064_f32,
    0.945_f32,  0.719_f32,  0.592_f32,
    0.543_f32,  0.021_f32,  0.978_f32,

    0.279_f32,  0.317_f32,  0.505_f32,
    0.167_f32,  0.620_f32,  0.077_f32,
    0.347_f32,  0.857_f32,  0.137_f32,

    0.055_f32,  0.953_f32,  0.042_f32,
    0.714_f32,  0.505_f32,  0.345_f32,
    0.783_f32,  0.290_f32,  0.734_f32,

    0.722_f32,  0.645_f32,  0.174_f32,
    0.302_f32,  0.455_f32,  0.848_f32,
    0.225_f32,  0.587_f32,  0.040_f32,

    0.517_f32,  0.713_f32,  0.338_f32,
    0.053_f32,  0.959_f32,  0.120_f32,
    0.393_f32,  0.621_f32,  0.362_f32,

    0.673_f32,  0.211_f32,  0.457_f32,
    0.820_f32,  0.883_f32,  0.371_f32,
    0.982_f32,  0.099_f32,  0.879_f32
  ]

  def vertices
    @@vertices
  end

  def uv
    @@uv
  end

  def colors
    @@colors
  end

  def name
    @@name
  end
end