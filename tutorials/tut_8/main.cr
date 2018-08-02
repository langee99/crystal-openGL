require "../../src/libs/gl"
require "../../src/libs/glew"
require "../../src/libs/glfw"
require "../../src/libs/glm"
require "../../src/libs/soil"
require "../../src/models/triangle"
require "../../src/common/controller"
require "../../src/common/loaders"

VERTEX_SHADER_LOC = "./tutorials/tut_8/shaders/standard_shading.glsl"
FRAGMENT_SHADER_LOC = "./tutorials/tut_8/shaders/standard_shading_fragment.glsl"
BMP_LOC = "src/bmps/uvtemplate.bmp"

class Main
  @program : GL::ShaderProgram
  @mvp : GLM::TMat4(Float32)
  @texture : LibGL::Uint
  @vert : Array(GLM::Vec3)
  @uv : Array(GLM::Vec2)
  @normal : Array(GLM::Vec3)

  @last_time = GLFW.get_time()
  @speed = 13.0_f32
  @angle = 0.0_f32

  # Draw mode
  @mode = "FILL"
  # Cull triangles which normal is not towards camera (Keeps drawing/rendering to only what's being shown)
  @cull = true
  # Should we be spinning?
  @spin = false

  def initialize
    unless GLFW.init
      raise "Failed to initialize GLFW"
    end

    @width = 1024
    @height = 768

    @background_color = [0.2, 0.1, 0.25, 0.0]

    GLFW.window_hint(GLFW::SAMPLES, 4)
    GLFW.window_hint(GLFW::CONTEXT_VERSION_MAJOR, 3)
    GLFW.window_hint(GLFW::CONTEXT_VERSION_MINOR, 3)
    GLFW.window_hint(GLFW::OPENGL_FORWARD_COMPAT, LibGL::TRUE)
    GLFW.window_hint(GLFW::OPENGL_PROFILE, GLFW::OPENGL_CORE_PROFILE)

    @window = GLFW.create_window(@width, @height, "OpenGL", nil, nil)

    raise "Failed to open GLFW window" if @window.null?
    GLFW.set_current_context @window

    GLEW.experimental = LibGL::TRUE
    unless GLEW.init == GLEW::OK
      raise "Failed to initialize GLEW"
    end

    # Set our controller to handle movement inputs and projections
    @controller = Controller.new @window

    # Make sure we can capture escape key
    GLFW.set_input_mode(@window, GLFW::STICKY_KEYS, LibGL::TRUE)

    # Hide the cursor
    GLFW.set_input_mode(@window, GLFW::CURSOR, GLFW::CURSOR_DISABLED)

    # Set mouse at center
    GLFW.poll_events()
    GLFW.set_cursor_pos(@window, @height/2, @width/2)

    # Set our background color
    GL.clear_color @background_color

    # Enable depth test
    LibGL.enable(LibGL::DEPTH_TEST)

    # Accept fragment if it's closer to the camera
    LibGL.depth_func(LibGL::LESS)

    # Cull triangles which normal is not towards camera
    LibGL.enable(LibGL::CULL_FACE)

    # Generate and bind vertex array
    gl_checked LibGL.gen_vertex_arrays(1, out @vertex_array_id)
    LibGL.bind_vertex_array(@vertex_array_id)

    # Load shaders
    @program = Loaders.load_shaders(VERTEX_SHADER_LOC, FRAGMENT_SHADER_LOC)

    # Get a handle for our "MVP"
    @matrix_id = LibGL.get_uniform_location(@program.program_id, "MVP")
    @view_matrix_id = LibGL.get_uniform_location(@program.program_id, "V")
    @model_matrix_id = LibGL.get_uniform_location(@program.program_id, "M")

    @mvp = GLM::Mat4.identity

    # Load textures
    @texture = Loaders.load_bmp(BMP_LOC)
    @texture_id = LibGL.get_uniform_location(@program.program_id, "myTextureSampler")
    @vert, @uv, @normal = Loaders.load_obj("./src/models/suzanne.obj")

    # @TODO: Figure out a way to get this to work without converting GLM::Vec3 and GLM::Vec2
    #   into an array to get this to work
    mapped_vert = [] of Float32
    mapped_uv = [] of Float32
    mapped_normal = [] of Float32
    @vert.each { |x| mapped_vert.concat x.to_a }
    @uv.each { |x| mapped_uv.concat x.to_a }
    @normal.each { |x| mapped_normal.concat x.to_a }

    # Vertex buffer
    LibGL.gen_buffers(1_f32, out @vertex_buffer)
    LibGL.bind_buffer(LibGL::ARRAY_BUFFER, @vertex_buffer)
    LibGL.buffer_data(LibGL::ARRAY_BUFFER, mapped_vert.size * sizeof(Float32), mapped_vert.to_unsafe, LibGL::STATIC_DRAW)

    # @TODO: MAKE ME WORK GDI
    # LibGL.buffer_data(LibGL::ARRAY_BUFFER, @vert.size * sizeof(GLM::Vec3), (@vert.to_unsafe.as Pointer(Void)), LibGL::STATIC_DRAW)

    # uv buffer
    LibGL.gen_buffers(1_f32, out @uv_buffer)
    LibGL.bind_buffer(LibGL::ARRAY_BUFFER, @uv_buffer)
    LibGL.buffer_data(LibGL::ARRAY_BUFFER, mapped_uv.size * sizeof(Float32), mapped_uv.to_unsafe, LibGL::STATIC_DRAW)

    # @TODO: MAKE ME WORK GDI
    # LibGL.buffer_data(LibGL::ARRAY_BUFFER, @uv.size * sizeof(GLM::Vec2), (@uv.to_unsafe.as Pointer(Void)), LibGL::STATIC_DRAW)

    # normal buffer
    LibGL.gen_buffers(1_f32, out @normal_buffer)
    LibGL.bind_buffer(LibGL::ARRAY_BUFFER, @normal_buffer)
    LibGL.buffer_data(LibGL::ARRAY_BUFFER, mapped_normal.size * sizeof(Float32), mapped_normal.to_unsafe, LibGL::STATIC_DRAW)

    # @TODO: MAKE ME WORK GDI
    # LibGL.buffer_data(LibGL::ARRAY_BUFFER, @normal.size * sizeof(GLM::Vec3), (@normal.to_unsafe.as Pointer(Void)), LibGL::STATIC_DRAW)

    # Get a handle for our LightPosition uniform
    @program.use
    @light_id = LibGL.get_uniform_location(@program.program_id, "LightPosition_worldspace")

    run
  end

  def run
    while true
      render

      # Check inputs outside of @controller as these rendering options instead
      #   of movement calculations
      GLFW.poll_events
      if (GLFW.get_key(@window, GLFW::KEY_F) == GLFW::PRESS)
        if (GLFW.get_key(@window, GLFW::KEY_F) == GLFW::RELEASE)
          if @mode == "LINE"
            LibGL.polygon_mode(LibGL::FRONT_AND_BACK, LibGL::FILL)
            @mode = "FILL"
          else
            LibGL.polygon_mode(LibGL::FRONT_AND_BACK, LibGL::LINE)
            @mode = "LINE"
          end
        end
      end
      if (GLFW.get_key(@window, GLFW::KEY_C) == GLFW::PRESS)
        if (GLFW.get_key(@window, GLFW::KEY_C) == GLFW::RELEASE)
          if @cull
            LibGL.disable(LibGL::CULL_FACE)
            @cull = false
          else
            LibGL.enable(LibGL::CULL_FACE)
            @cull = true
          end
        end
      end
      if (GLFW.get_key(@window, GLFW::KEY_V) == GLFW::PRESS)
        if (GLFW.get_key(@window, GLFW::KEY_V) == GLFW::RELEASE)
          if @spin
            @spin = false
          else
            @spin = true
          end
        end
      end
      break if GLFW.get_key(@window, GLFW::KEY_ESCAPE) == GLFW::PRESS && GLFW.window_should_close(@window)
    end

    # Cleanup
    LibGL.disable_vertex_attrib_array 0_u32
    LibGL.disable_vertex_attrib_array 1_u32
    LibGL.disable_vertex_attrib_array 2_u32

    # Close OpenGL window
    GLFW.terminate
  end

  def render
    current_time = GLFW.get_time
    delta_time = current_time - @last_time
    @last_time = current_time

    # Clear the screen
    LibGL.clear(LibGL::COLOR_BUFFER_BIT | LibGL::DEPTH_BUFFER_BIT)

    # Use our shader
    @program.use

    # Compute the MVP matrix
    @controller.compute_matricies_from_inputs
    projection_matrix = @controller.projection_matrix
    view_matrix = @controller.view_matrix
    model_matrix = GLM::Mat4.identity # Identity matrix

    # If we should be spinning calculate new angle
    if @spin
      @angle += Math.sin(@speed) * delta_time
    end

    @mvp = GLM.rotate(projection_matrix * view_matrix * model_matrix, @angle, GLM.vec3(1, 1, 1))

    # Send our transform to the currently bound shader,
    # in the "MVP" uniform
    LibGL.uniform_matrix_4fv(@matrix_id, 1, LibGL::FALSE, @mvp.buffer)
    LibGL.uniform_matrix_4fv(@model_matrix_id, 1, LibGL::FALSE, model_matrix.buffer)
    LibGL.uniform_matrix_4fv(@view_matrix_id, 1, LibGL::FALSE, view_matrix.buffer)

    light_pos = GLM.vec3(4, 4, 4)
    LibGL.uniform_3f(@light_id, light_pos.x, light_pos.y, light_pos.z)

    # Bind texture in texture unit 0
    LibGL.active_texture(LibGL::TEXTURE0)
    LibGL.bind_texture(LibGL::TEXTURE_2D, @texture)

    # Set our "myTextureSampler" sampler to use Texture unit 0
    LibGL.uniform1i(@texture_id, 0)

    # 1st attribute buffer: Verticies
    LibGL.enable_vertex_attrib_array(0)
    LibGL.bind_buffer(LibGL::ARRAY_BUFFER, @vertex_buffer)
    LibGL.vertex_attrib_pointer(0, 3, LibGL::FLOAT, LibGL::FALSE, 0, Pointer(Void).new(0))

    # 2nd attribute buffter: UVs
    LibGL.enable_vertex_attrib_array(1)
    LibGL.bind_buffer(LibGL::ARRAY_BUFFER, @uv_buffer)
    LibGL.vertex_attrib_pointer(1, 2, LibGL::FLOAT, LibGL::FALSE, 0, Pointer(Void).new(0))

    # 3rd attribute buffter: Normals
    LibGL.enable_vertex_attrib_array(2)
    LibGL.bind_buffer(LibGL::ARRAY_BUFFER, @normal_buffer)
    LibGL.vertex_attrib_pointer(2, 3, LibGL::FLOAT, LibGL::FALSE, 0, Pointer(Void).new(0))

    # Draw the triangle
    LibGL.draw_arrays(LibGL::TRIANGLES, 0, @vert.size)

    LibGL.disable_vertex_attrib_array(0)
    LibGL.disable_vertex_attrib_array(1)
    LibGL.disable_vertex_attrib_array(2)

    # Swap buffers
    GLFW.swap_buffers(@window)
  end
end

begin
  Main.new
rescue exception
  puts exception
end
