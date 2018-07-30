module Loaders
  # Loader for handling .bmp files
  def self.load_bmp(file_loc : String)
    header = [] of UInt8
    file = File.open(file_loc, "rb")
    file.each_byte do |byte|
      if header.size < 54
        header.push byte
      end
    end

    # Make sure this is a bmp file
    if (header[0].unsafe_chr != 'B' || header[1].unsafe_chr != 'M')
      raise "Not a correct BMP File"
    end

    data_pos = header[0x0A]

    # Grab 4 bytes from the specified position
    # Join them together and convert to int using a base of 16
    image_size = header[0x22, 4].join("").to_i(16)
    width = header[0x12, 4].join("").to_i(16)
    height = header[0x16, 4].join("").to_i(16)

    # Image size might not have been given so calculate it from the width and height
    if image_size === 0
      image_size = width * height * 3 # *3 so 1 byte per color
    end


    data = file.seek(data_pos + 1).gets_to_end()
    file.close

    LibGL.gen_textures(1_f32, out texture_id)
    LibGL.bind_texture(LibGL::TEXTURE_2D, texture_id)

    LibGL.tex_image_2d(LibGL::TEXTURE_2D, 0, LibGL::RGB, width, height, 0, LibGL::BGR, LibGL::UNSIGNED_BYTE, data.to_unsafe)

    LibGL.tex_parameteri(LibGL::TEXTURE_2D, LibGL::TEXTURE_WRAP_S, LibGL::REPEAT)
    LibGL.tex_parameteri(LibGL::TEXTURE_2D, LibGL::TEXTURE_WRAP_T, LibGL::REPEAT)
    LibGL.tex_parameteri(LibGL::TEXTURE_2D, LibGL::TEXTURE_MAG_FILTER, LibGL::LINEAR)
    LibGL.tex_parameteri(LibGL::TEXTURE_2D, LibGL::TEXTURE_MIN_FILTER, LibGL::LINEAR_MIPMAP_LINEAR)
    LibGL.generate_mipmap(LibGL::TEXTURE_2D)

    texture_id
  end

  # Loader for handling .obj files
  def self.load_obj(file_loc : String)
    file = File.open(file_loc)

    if !file
      raise "Unable to open Object file at #{file_loc}"
    end

    out_vertices = [] of GLM::Vec3
    out_uvs = [] of GLM::Vec2
    out_normals = [] of GLM::Vec3

    temp_vertices = [] of GLM::Vec3
    temp_uvs = [] of GLM::Vec2
    temp_normals = [] of GLM::Vec3

    vertex_indices, uv_indices, normal_indices = [] of UInt32, [] of UInt32, [] of UInt32

    file.each_line do |line|
      if line.starts_with?("vn")
        normal = GLM.vec3(0, 0, 0)
        x = line.scan(/([-]?\d\.\d*)/).map do |x| x[1].to_f32 end

        normal.x = x[0]
        normal.y = x[1]
        normal.z = x[2]

        temp_normals.push(normal)
      elsif line.starts_with?("vt")
        x = line.scan(/([-]?\d\.\d*)/).map do |x| x[1].to_f32 end
        uv = GLM.vec2(0, 0)

        uv.x = x[0]
        uv.y = x[1]

        temp_uvs.push(uv)
      elsif line.starts_with?("v")
        x = line.scan(/([-]?\d\.\d*)/).map do |x| x[1].to_f32 end
        vertex = GLM.vec3(0, 0, 0)

        vertex.x = x[0]
        vertex.y = x[1]
        vertex.z = x[2]
        temp_vertices.push(vertex)

        # temp_vertices.push(GLM.vec3(x[0], x[1], x[2]))
      elsif line.starts_with?("f")
        x = line.scan(/(\d*\/\d*\/\d* \d*\/\d*\/\d* \d*\/\d*\/\d*)/).map do |x|
          first, second, third = x[1].split(" ")

          # First vertex
          x = first.split("/")
          vertex_indices.push(x[0].to_u32)
          uv_indices.push(x[1].to_u32)
          normal_indices.push(x[2].to_u32)


          # Second vertex
          x = second.split("/")
          vertex_indices.push(x[0].to_u32)
          uv_indices.push(x[1].to_u32)
          normal_indices.push(x[2].to_u32)

          # Third vertex
          x = third.split("/")
          vertex_indices.push(x[0].to_u32)
          uv_indices.push(x[1].to_u32)
          normal_indices.push(x[2].to_u32)
        end
      end
    end

    vertex_indices.each_with_index do |x, i|
      vertex_index = vertex_indices[i]
      uv_index = uv_indices[i]
      normal_index = normal_indices[i]

      vertex = temp_vertices[vertex_index - 1]
      uv = temp_uvs[uv_index - 1]
      normal = temp_normals[normal_index - 1]

      out_vertices.push(vertex)
      out_uvs.push(uv)
      out_normals.push(normal)
    end

    file.close

    return out_vertices, out_uvs, out_normals
  end

  # Loader for handling shaders
  def self.load_shaders(vertex_shader_loc : String, fragment_shader_loc : String)
    # vertex_shader_code = File.read("src/openGL/shaders/vertex_shader.glsl")
    # fragment_shader_code = File.read("src/openGL/shaders/fragment_shader.glsl")

    vertex_shader_code = File.read(vertex_shader_loc)
    fragment_shader_code = File.read(fragment_shader_loc)

    vertex_shader = GL::VertexShader.new(vertex_shader_code).compile
    fragment_shader = GL::FragmentShader.new(fragment_shader_code).compile

    program = GL::ShaderProgram.new
    program.attach vertex_shader
    program.attach fragment_shader
    program.link

    vertex_shader.delete
    fragment_shader.delete

    program
  end
end
