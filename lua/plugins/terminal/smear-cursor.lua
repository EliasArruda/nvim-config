return {
  "sphamba/smear-cursor.nvim",
  opts = {
    -- Animação ao mudar de buffer ou janela
    smear_between_buffers = true,
    -- Animação entre linhas
    smear_between_neighbor_lines = true,
    -- Desenha no espaço do buffer
    scroll_buffer_space = true,
    -- Suporte a símbolos legados (melhor visual)
    legacy_computing_symbols_support = true,
    -- Habilitar enquanto digita (insert mode)
    smear_insert_mode = true,

    -- Configuração da física da animação
    stiffness = 0.8,
    trailing_stiffness = 0.6,
    stiffness_insert_mode = 0.7,
    trailing_stiffness_insert_mode = 0.7,
    damping = 0.95,
    damping_insert_mode = 0.95,
    distance_stop_animating = 0.5,
    time_interval = 7, -- mais rápido que o padrão (17ms)

    -- Cor do smear
    cursor_color = "#d3cdc3",

    -- Partículas para efeito visual
    particles_enabled = true,
    particle_spread = 1,
    particles_per_second = 200,
    particle_max_lifetime = 500,
    particle_max_initial_velocity = 15,
    particle_velocity_from_cursor = 0.5,
    particle_damping = 0.2,
    particle_gravity = -30,
    min_distance_emit_particles = 0.2,

    -- Evita duplicar o cursor
    hide_target_hack = true,
    never_draw_over_target = true,
  },
}
