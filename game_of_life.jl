using CairoMakie
using Printf

"""
    count_neighbors(grid::Matrix{Int}, i::Int, j::Int)

Count the number of live neighbors for cell at position (i, j).
"""
function count_neighbors(grid::Matrix{Int}, i::Int, j::Int)
    rows, cols = size(grid)
    count = 0
    
    # Check all 8 neighboring cells
    for di in -1:1
        for dj in -1:1
            # Skip the cell itself
            if di == 0 && dj == 0
                continue
            end
            
            # Calculate neighbor position with periodic boundary conditions
            ni = mod1(i + di, rows)
            nj = mod1(j + dj, cols)
            
            count += grid[ni, nj]
        end
    end
    
    return count
end

"""
    apply_rules(grid::Matrix{Int})

Apply Conway's Game of Life rules to create the next generation.
Rules:
1. Any live cell with 2 or 3 live neighbors survives
2. Any dead cell with exactly 3 live neighbors becomes alive
3. All other live cells die, and all other dead cells stay dead
"""
function apply_rules(grid::Matrix{Int})
    rows, cols = size(grid)
    new_grid = zeros(Int, rows, cols)
    
    for i in 1:rows
        for j in 1:cols
            neighbors = count_neighbors(grid, i, j)
            
            if grid[i, j] == 1  # Cell is alive
                if neighbors in [2, 3]
                    new_grid[i, j] = 1
                end
            else  # Cell is dead
                if neighbors == 3
                    new_grid[i, j] = 1
                end
            end
        end
    end
    
    return new_grid
end

"""
    create_transition_matrix(prev_state::Matrix{Int}, curr_state::Matrix{Int})

Create a transition matrix that encodes the state changes between generations.
Returns a matrix with values:
- 0: dead -> dead
- 1: alive -> dead
- 2: dead -> alive
- 3: alive -> alive 
"""
function create_transition_matrix(prev_state::Matrix{Int}, curr_state::Matrix{Int})
    rows, cols = size(prev_state)
    transition_matrix = zeros(Int, rows, cols)
    
    for i in 1:rows
        for j in 1:cols
            if prev_state[i, j] == 0 && curr_state[i, j] == 0
                transition_matrix[i, j] = 0  # dead -> dead
            elseif prev_state[i, j] == 1 && curr_state[i, j] == 0
                transition_matrix[i, j] = 1  # alive -> dead
            elseif prev_state[i, j] == 0 && curr_state[i, j] == 1
                transition_matrix[i, j] = 2  # dead -> alive
            else  # prev_state[i, j] == 1 && curr_state[i, j] == 1
                transition_matrix[i, j] = 3  # alive -> alive
            end
        end
    end
    
    return transition_matrix
end

"""
    simulate_game_of_life(initial_state::Matrix{Int}, n::Int)

Simulate n generations of Conway's Game of Life starting from initial_state.
Returns an array of transition matrices showing state changes between generations.
"""
function simulate_game_of_life(initial_state::Matrix{Int}, n::Int)
    states = Vector{Matrix{Int}}()
    transition_matrices = Vector{Matrix{Int}}()
    
    push!(states, copy(initial_state))
    
    # For the first frame, we'll show all cells as "dead -> current state"
    first_transition = zeros(Int, size(initial_state))
    for i in eachindex(initial_state)
        if initial_state[i] == 0
            first_transition[i] = 0  # dead -> dead
        else
            first_transition[i] = 2  # dead -> alive (initial birth)
        end
    end
    push!(transition_matrices, first_transition)
    
    current_state = copy(initial_state)
    
    for _ in 1:n
        next_state = apply_rules(current_state)
        push!(states, copy(next_state))
        
        # Create transition matrix
        transition_matrix = create_transition_matrix(current_state, next_state)
        push!(transition_matrices, transition_matrix)
        
        current_state = next_state
    end
    
    return states, transition_matrices
end

"""
    create_animation(transition_matrices::Vector{Matrix{Int}}, filename::String="game_of_life.mp4"; 
                    fps::Int=10)
"""
function create_animation(transition_matrices::Vector{Matrix{Int}}, filename::String="game_of_life.mp4"; 
                         fps::Int=10)
    rows, cols = size(transition_matrices[1])
    
    # Standard video dimensions for all animations
    fig_width = 1200
    fig_height = 1200
    fig = Figure(size = (fig_width, fig_height), backgroundcolor = :black,
                 figure_padding = 0)
    
    ax = Axis(fig[1, 1], 
              aspect = 1.0,
              backgroundcolor = :black,
              titlesize = 20,
              titlecolor = :white,
              titlefont = "Helvetica",
              leftspinevisible = true,
              rightspinevisible = true,
              bottomspinevisible = true,
              topspinevisible = true,
              titlegap = 8)
    
    # Configure layout to fill the entire video area
    rowsize!(fig.layout, 1, Auto())
    colsize!(fig.layout, 1, Auto())
    
    # Remove all margins and padding to fill the entire frame
    fig.layout.alignmode = Outside(0, 0, 0, 0)
    
    # Remove axis decorations but keep title
    hidedecorations!(ax, grid = false, ticks = false, ticklabels = false, 
                    label = false, minorticks = false)
    
    # Create an observable for the heatmap data
    heatmap_data = Observable(transition_matrices[1])
    
    custom_colormap = :RdPu_4
    
    # Set up the heatmap with the transition color scheme
    hm = heatmap!(ax, heatmap_data, 
                  colormap = custom_colormap,
                  colorrange = (0, 3),  # 4 discrete states
                  interpolate = false)  # Sharp cell boundaries
    
    # Ensure axis fills the entire allocated space
    ax.alignmode = Outside(0, 0, 0, 0)
    
    # Add subtle grid lines to show individual cells
    grid_color = :black
    for i in 1:rows+1
        lines!(ax, [0.5, cols + 0.5], [i - 0.5, i - 0.5], 
               color = grid_color, linewidth = 0.5)
    end
    for j in 1:cols+1
        lines!(ax, [j - 0.5, j - 0.5], [0.5, rows + 0.5], 
               color = grid_color, linewidth = 0.5)
    end
    
    # Create animation with smooth transitions
    record(fig, filename, 1:length(transition_matrices); framerate = fps) do frame_idx
        heatmap_data[] = transition_matrices[frame_idx]
        
        # Title with generation info and transition legend
        generation = frame_idx - 1
        if generation == 0
            ax.title = "Conway's Game of Life - Initial State\nWhite: Dead→Dead | Lighter Pink: Alive→Dead | Darker Pink: Dead→Alive | Purple: Alive→Alive"
        else
            # Count different transition types in current frame
            transitions = transition_matrices[frame_idx]
            dead_to_dead = count(x -> x == 0, transitions)
            alive_to_dead = count(x -> x == 1, transitions)
            dead_to_alive = count(x -> x == 2, transitions)
            alive_to_alive = count(x -> x == 3, transitions)
            
            ax.title = @sprintf("Conway's Game of Life - Generation: %d\nBirths: %d | Deaths: %d | Survivors: %d | Inactive: %d", 
                               generation, dead_to_alive, alive_to_dead, alive_to_alive, dead_to_dead)
        end
    end
    
    return filename
end

"""
    game_of_life(initial_state::Matrix{Int}, n::Int; 
                filename::String="game_of_life.mp4", fps::Int=10)

Main function to run Conway's Game of Life simulation and create a MP4 video.
Uses transition-based coloring with RdPu_4 palette:
- White: Cell was dead and stayed dead
- Lighter Pink: Cell was alive and died  
- Darker Pink: Cell was dead and became alive
- Purple: Cell was alive and stayed alive

# Arguments
- `initial_state::Matrix{Int}`: Initial grid state (1 = alive, 0 = dead)
- `n::Int`: Number of generations to simulate
- `filename::String`: Output video filename (default: "game_of_life.mp4")
- `fps::Int`: Frames per second for the video (default: 10)

# Returns
- Path to the created MP4 file
"""
function game_of_life(initial_state::Matrix{Int}, n::Int; 
                     filename::String="game_of_life.mp4", fps::Int=10)
    # Validate input
    if !all(x -> x in [0, 1], initial_state)
        error("Initial state must contain only 0s and 1s")
    end
    
    if n < 0
        error("Number of generations must be non-negative")
    end
    
    # Simulate the game
    println("Simulating $n generations...")
    states, transition_matrices = simulate_game_of_life(initial_state, n)
    
    
    create_animation(transition_matrices, filename; fps=fps)
    
    println("Animation saved to: $filename")
    return filename
end