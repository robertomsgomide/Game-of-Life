# Conway's Game of Life

A simple Julia snippet implementation of Conway's Game of Life that generates animations with transition-based visualization.  
<table>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/19951c0a-baa6-4a53-8af4-4f7e5bfd6048" width="350" alt="U"><br>
      <sub>U</sub>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/9aa6f91a-41a7-415a-b300-ed1cd97345cb" width="350" alt="Gosper Glider Gun"><br>
      <sub>Gosper Glider Gun</sub>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/044b8ff1-7cd7-4016-a768-96e90368dd08" width="350" alt="Rorschach Pattern"><br>
      <sub>"Rorschach" Pattern</sub>
    </td>
    <td align="center">
      <img src="https://github.com/user-attachments/assets/d6e8657f-8d36-4757-8163-6a83fd32001a" width="350" alt="Random state evolution"><br>
      <sub>Random state evolution</sub>
    </td>
  </tr>
</table>  

## Features

- **Transition visualization**: Colors cells based on state changes between generations rather than just current state
- **MP4 export**: Creates video animations using CairoMakie
- **Periodic boundaries**: Wraparound grid edges for continuous simulation
- **Classic patterns**: Includes implementations of well-known Game of Life patterns
- **Configurable**: Adjustable grid size, generation count, and frame rate

## Requirements

- Julia 1.6+
- CairoMakie.jl

```julia
using Pkg
Pkg.add("CairoMakie")
```

## Usage

### Basic simulation

```julia
include("game_of_life.jl")

# Create initial state (1 = alive, 0 = dead)
initial_state = [
    0 1 0
    0 0 1
    1 1 1
]

# Run simulation for 50 generations
game_of_life(initial_state, 50, filename="output.mp4", fps=10)
```

### Using predefined patterns

```julia
include("tests.jl")

# Run classic patterns
initial_state = create_glider()
game_of_life(initial_state, 60, filename="glider.mp4", fps=20)
```

## Color Scheme

The animation uses a transition-based color scheme/palette:
- **White**: Dead → Dead
- **Light Pink**: Alive → Dead  
- **Dark Pink**: Dead → Alive
- **Purple**: Alive → Alive

## Available Patterns

| Pattern | Description |
|---------|-------------|
| `create_glider()` | Classic glider |
| `create_gosper_glider_gun()` | Glider generator | 
| `create_pulsar()` | Period-3 oscillator |
| `create_acorn()` | Methuselah pattern |
| `create_lwss()` | Light-weight spaceship |
| `create_random_state(rows, cols, density)` | Random configuration |

## Implementation Details

- **Neighbor counting**: Uses Moore neighborhood (8-connected)
- **Boundary conditions**: Periodic (toroidal topology)
- **Rules**: Standard Conway's Game of Life rules
- **Animation**: 1200x1200 pixel output with configurable frame rate
- **Performance**: Efficient matrix operations for large grids

## File Structure

```
├── game_of_life.jl    # Core implementation
└── tests.jl           # Pattern definitions and examples
```



## License
MIT
