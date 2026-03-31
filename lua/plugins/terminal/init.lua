-- ~/.config/nvim/lua/plugins/terminal/init.lua

return {

  -- image.nvim sem luarocks.nvim
  {
    "3rd/image.nvim",
    config = function()
      -- Verifica se hererocks está disponível
      local ok, _ = pcall(require, "image")
      if not ok then
        vim.notify("image.nvim não carregado - hererocks pode estar faltando", vim.log.levels.WARN)
        return
      end

      require("image").setup({
        backend = "kitty",
        max_height_window_percentage = 50,
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.svg" },
      })
    end,
  },

  -- smear-cursor (independente)
  {
    "sphamba/smear-cursor.nvim",
    opts = {
      -- suas configs completas aqui
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      scroll_buffer_space = true,
      legacy_computing_symbols_support = true,
      smear_insert_mode = true,
      stiffness = 0.8,
      trailing_stiffness = 0.6,
      stiffness_insert_mode = 0.7,
      trailing_stiffness_insert_mode = 0.7,
      damping = 0.95,
      damping_insert_mode = 0.95,
      distance_stop_animating = 0.5,
      time_interval = 7,
      cursor_color = "#d3cdc3",
      particles_enabled = true,
      particle_spread = 1,
      particles_per_second = 200,
      particle_max_lifetime = 500,
      particle_max_initial_velocity = 15,
      particle_velocity_from_cursor = 0.5,
      particle_damping = 0.2,
      particle_gravity = -30,
      min_distance_emit_particles = 0.2,
      hide_target_hack = true,
      never_draw_over_target = true,
    },
  },
}
