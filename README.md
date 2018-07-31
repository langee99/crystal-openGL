# openGL

Implement openGL bindings in Crystal

## Installation

Installing crystal with homebrew (macOS)
```bash
# Install homebrew (If you dont have it)
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Update brew
brew update

# Install crystal, glfw, and glew
brew install crystal glfw glew
```

## Usage

```bash
crystal src/main.cr
```

```
Key bindings:
  - Mouse movements => Camera Look
  - WASD/Arrow keys => Camera Movement
  - Z => Increase FoV
  - X => Decrease FoV
  - C => Toggle Culling
  - F => Draw Mode (Fill or Line)
  - V => Toggle Spinning
  - ESC => Quit
```

## Development

Lots of things. Currently renders a cube from `src/models/cube_tex.cr`. Other `*.cr` models should theoretically work with some changes. Working on getting loading from `.obj` files

## Contributing

1. Fork it (<https://github.com/langee99/openGL-crystal/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [langee99](https://github.com/langee99) Eric Lange - creator, maintainer
