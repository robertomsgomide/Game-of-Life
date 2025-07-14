include("game_of_life.jl")

#example patterns

function create_glider()
    grid = zeros(Int, 60, 60)
    center_row, center_col = 30, 30
    grid[center_row, center_col] = 1
    grid[center_row + 1, center_col + 1] = 1
    grid[center_row + 2, center_col - 1:center_col + 1] .= 1
    return grid
end

function create_random_state(rows::Int, cols::Int, density::Float64=0.5)
    return Int.(rand(rows, cols) .< density)
end

function create_acorn()
    grid = zeros(Int, 120, 120) 
    offset_row, offset_col = 55, 55

    grid[offset_row, offset_col + 1] = 1
    grid[offset_row + 1, offset_col + 3] = 1
    grid[offset_row + 2, offset_col] = 1
    grid[offset_row + 2, offset_col + 1] = 1
    grid[offset_row + 2, offset_col + 4] = 1
    grid[offset_row + 2, offset_col + 5] = 1
    grid[offset_row + 2, offset_col + 6] = 1

    return grid
end

function create_lwss()
    grid = zeros(Int, 40, 40)
    offset_row, offset_col = 20, 20

    grid[offset_row, offset_col - 1] = 1
    grid[offset_row, offset_col + 2] = 1
    grid[offset_row + 1, offset_col - 2] = 1
    grid[offset_row + 2, offset_col - 2] = 1
    grid[offset_row + 2, offset_col + 2] = 1
    grid[offset_row + 3, offset_col - 2] = 1
    grid[offset_row + 3, offset_col - 1] = 1
    grid[offset_row + 3, offset_col] = 1
    grid[offset_row + 3, offset_col + 1] = 1

    return grid
end

function create_pulsar()
    grid = zeros(Int, 25, 25)
    offset_row, offset_col = 5, 5

    pulsar_points = [
        (2, 4), (2, 5), (2, 6), (2, 10), (2, 11), (2, 12),
        (4, 2), (4, 7), (4, 9), (4, 14),
        (5, 2), (5, 7), (5, 9), (5, 14),
        (6, 2), (6, 7), (6, 9), (6, 14),
        (7, 4), (7, 5), (7, 6), (7, 10), (7, 11), (7, 12),
        (9, 4), (9, 5), (9, 6), (9, 10), (9, 11), (9, 12),
        (10, 2), (10, 7), (10, 9), (10, 14),
        (11, 2), (11, 7), (11, 9), (11, 14),
        (12, 2), (12, 7), (12, 9), (12, 14),
        (14, 4), (14, 5), (14, 6), (14, 10), (14, 11), (14, 12)
    ]

    for (r, c) in pulsar_points
        grid[offset_row + r, offset_col + c] = 1
    end

    return grid
end

function create_gosper_glider_gun()
    grid = zeros(Int, 60, 60)
    
    offset_row = 26
    offset_col = 12
    
    # Left box
    grid[offset_row, offset_col] = 1
    grid[offset_row, offset_col + 1] = 1
    grid[offset_row + 1, offset_col] = 1
    grid[offset_row + 1, offset_col + 1] = 1
    
    # Left part of gun
    grid[offset_row, offset_col + 10] = 1
    grid[offset_row + 1, offset_col + 10] = 1
    grid[offset_row + 2, offset_col + 10] = 1
    grid[offset_row - 1, offset_col + 11] = 1
    grid[offset_row + 3, offset_col + 11] = 1
    grid[offset_row - 2, offset_col + 12] = 1
    grid[offset_row + 4, offset_col + 12] = 1
    grid[offset_row - 2, offset_col + 13] = 1
    grid[offset_row + 4, offset_col + 13] = 1
    grid[offset_row + 1, offset_col + 14] = 1
    grid[offset_row - 1, offset_col + 15] = 1
    grid[offset_row + 3, offset_col + 15] = 1
    grid[offset_row, offset_col + 16] = 1
    grid[offset_row + 1, offset_col + 16] = 1
    grid[offset_row + 2, offset_col + 16] = 1
    grid[offset_row + 1, offset_col + 17] = 1
    
    # Right part of gun
    grid[offset_row - 2, offset_col + 20] = 1
    grid[offset_row - 1, offset_col + 20] = 1
    grid[offset_row, offset_col + 20] = 1
    grid[offset_row - 2, offset_col + 21] = 1
    grid[offset_row - 1, offset_col + 21] = 1
    grid[offset_row, offset_col + 21] = 1
    grid[offset_row - 3, offset_col + 22] = 1
    grid[offset_row + 1, offset_col + 22] = 1
    grid[offset_row - 4, offset_col + 24] = 1
    grid[offset_row - 3, offset_col + 24] = 1
    grid[offset_row + 1, offset_col + 24] = 1
    grid[offset_row + 2, offset_col + 24] = 1
    
    # Right box
    grid[offset_row - 2, offset_col + 34] = 1
    grid[offset_row - 1, offset_col + 34] = 1
    grid[offset_row - 2, offset_col + 35] = 1
    grid[offset_row - 1, offset_col + 35] = 1
    
    return grid
end

function create_m_u()
    grid = zeros(Int, 50, 50)
    offset_row = 27
    offset_col = 1

    grid[offset_row    , offset_col + 27] = 1
    grid[offset_row    , offset_col + 29] = 1
    grid[offset_row+1  , offset_col + 27] = 1
    grid[offset_row+1  , offset_col + 29] = 1
    grid[offset_row+2  , offset_col + 27] = 1
    grid[offset_row+2  , offset_col + 28] = 1
    grid[offset_row+2  , offset_col + 29] = 1
    return grid
end

function create_rorschach()
    grid = zeros(Int, 57, 57)
    offset_row = 27
    offset_col = 1

    grid[offset_row    , offset_col + 28] = 1
    grid[offset_row + 1, offset_col + 27] = 1
    grid[offset_row + 1, offset_col + 28] = 1
    grid[offset_row + 1, offset_col + 29] = 1
    grid[offset_row + 2, offset_col + 26] = 1
    grid[offset_row + 2, offset_col + 28] = 1
    grid[offset_row + 2, offset_col + 30] = 1
    grid[offset_row + 3, offset_col + 26] = 1
    grid[offset_row + 3, offset_col + 28] = 1
    grid[offset_row + 3, offset_col + 30] = 1
    grid[offset_row + 4, offset_col + 23] = 1
    grid[offset_row + 4, offset_col + 24] = 1
    grid[offset_row + 4, offset_col + 26] = 1
    grid[offset_row + 4, offset_col + 27] = 1
    grid[offset_row + 4, offset_col + 28] = 1
    grid[offset_row + 4, offset_col + 29] = 1
    grid[offset_row + 4, offset_col + 30] = 1
    grid[offset_row + 4, offset_col + 32] = 1
    grid[offset_row + 4, offset_col + 33] = 1
    grid[offset_row + 5, offset_col + 23] = 1
    grid[offset_row + 5, offset_col + 25] = 1
    grid[offset_row + 5, offset_col + 31] = 1
    grid[offset_row + 5, offset_col + 33] = 1
    grid[offset_row + 6, offset_col + 26] = 1
    grid[offset_row + 6, offset_col + 27] = 1
    grid[offset_row + 6, offset_col + 28] = 1
    grid[offset_row + 6, offset_col + 29] = 1
    grid[offset_row + 6, offset_col + 30] = 1

    return grid
end

# Example usage
function test()
    # Example 1: Glider pattern
    println("Example 1: Glider pattern")
    initial_state = create_glider()
    game_of_life(initial_state, 60, filename="glider.mp4", fps=20)
    
    # Example 2: Gosper Glider Gun - the most famous pattern
    println("\nExample 2: Gosper Glider Gun")
    gun_pattern = create_gosper_glider_gun()
    game_of_life(gun_pattern, 260, filename="glider_gun.mp4", fps=20)
    
    # Example 3: Random initial state - complex evolution
    println("\nExample 3: Random state evolution")
    random_state = create_random_state(60, 60, 0.35)
    game_of_life(random_state, 260, filename="random_life.mp4", fps=20)

    # Example 4: Acorn pattern
    println("\nExample 4: Acorn pattern (Methuselah)")
    acorn = create_acorn()
    game_of_life(acorn, 200, filename="acorn.mp4", fps=20)

    # Example 5: U pattern
    println("\nExample 5: U pattern")
    m_u = create_m_u()
    game_of_life(m_u, 260, filename="m_u.mp4", fps=20)

    # Example 5: Pulsar pattern
    println("\nExample 5: Pulsar pattern")
    pulsar = create_pulsar()
    game_of_life(pulsar, 200, filename="pulsar.mp4", fps=20)

    # Example 5: LWSS pattern
    println("\nExample 5: Spaceship pattern")
    lwss = create_lwss()
    game_of_life(lwss, 200, filename="lwss.mp4", fps=20)

    # Example 6: 'Rorschach' pattern
    println("\nExample 6: Rorschach pattern")
    m_simetry = create_rorschach()
    game_of_life(m_simetry, 260, filename="rorschach.mp4", fps=20)
end