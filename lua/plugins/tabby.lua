return {
  'nanozuki/tabby.nvim',
  -- Tabline should render as soon as Vim starts up
  event = 'VimEnter',
  dependencies = {
    -- Required if you want beautiful file icons in your tabs
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    -- Initialize tabby with a preset layout
    require('tabby.tabline').use_preset('active_wins_at_tail', {
      theme = {
        fill = 'TabLineFill',       -- The background color of the remaining tab bar
        head = 'TabLine',           -- The leftmost text/label (if any)
        current_tab = 'TabLineSel', -- The currently active tab
        tab = 'TabLine',            -- Inactive tabs
        win = 'TabLine',            -- Individual windows listed inside tabs
        tail = 'TabLine',           -- The rightmost side elements
      },
      options = {
        buf_name = {
          mode = 'unique',          -- Shows a unique file/buffer name for clarity
        },
      },
    })
  end,
}
