class Controller
  getter view_matrix = GLM::Mat4.zero
  getter projection_matrix = GLM::Mat4.zero

  def initialize(@window : GLFW::Window)
    @position = GLM.vec3(0, 0, 5)
    @horizontal_angle = 3.14_f32
    @vertical_angle = 0.0_f32
    @speed = 3.0_f32
    @mouse_speed = 0.005_f32
    @fov = 45.0_f32
    @last_time = GLFW.get_time()
  end

  def compute_matricies_from_inputs()
    current_time = GLFW.get_time()

    delta_time = current_time - @last_time

    GLFW.get_cursor_pos(@window, out xpos, out ypos)

    GLFW.set_cursor_pos(@window, 768/2, 1024/2)


    @horizontal_angle += @mouse_speed * ((768/2) - xpos)
    @vertical_angle += @mouse_speed * ((1024/2) - ypos)

    direction = GLM.vec3(
      Math.cos(@vertical_angle) * Math.sin(@horizontal_angle),
      Math.sin(@vertical_angle),
      Math.cos(@vertical_angle) * Math.cos(@horizontal_angle)
    )

    right = GLM.vec3(
      Math.sin(@horizontal_angle - (3.14_f32/2.0_f32)),
      0,
      Math.cos(@horizontal_angle - (3.14_f32/2.0_f32))
    )

    up = right.cross( direction )

    handle_key_press(direction, right, delta_time)

    @projection_matrix = GLM.perspective(@fov, 4.0_f32 / 3.0_f32, 0.1_f32, 100_f32)

    @view_matrix = GLM.look_at(@position, @position + direction, up)

    @last_time = current_time
  end

  protected def handle_key_press(direction, right, delta_time)

    if (GLFW.get_key(@window, GLFW::KEY_UP) === GLFW::PRESS) || (GLFW.get_key(@window, GLFW::KEY_W) === GLFW::PRESS)
      @position += direction * delta_time * @speed
    end

    if (GLFW.get_key(@window, GLFW::KEY_DOWN) === GLFW::PRESS) || (GLFW.get_key(@window, GLFW::KEY_S) === GLFW::PRESS)
      @position -= direction * delta_time * @speed
    end

    if (GLFW.get_key(@window, GLFW::KEY_RIGHT) === GLFW::PRESS) || (GLFW.get_key(@window, GLFW::KEY_D) === GLFW::PRESS)
      @position += right * delta_time * @speed
    end

    if (GLFW.get_key(@window, GLFW::KEY_LEFT) === GLFW::PRESS) || (GLFW.get_key(@window, GLFW::KEY_A) === GLFW::PRESS)
      @position -= right * delta_time * @speed
    end

    if (GLFW.get_key(@window, GLFW::KEY_E) === GLFW::PRESS)
      @position += (right + direction) * delta_time * @speed
    end

    if (GLFW.get_key(@window, GLFW::KEY_Q) === GLFW::PRESS)
      @position -= (right - direction) * delta_time * @speed
    end

    if (GLFW.get_key(@window, GLFW::KEY_Z) === GLFW::PRESS)
      @fov += 1
      puts "FOV: #{@fov}"
    end

    if (GLFW.get_key(@window, GLFW::KEY_X) === GLFW::PRESS)
      @fov -= 1
      puts "FOV: #{@fov}"
    end
  end
end
