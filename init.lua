-- ========================================================================== --
-- 1. GLOBAL SETTINGS & LEADER KEY
-- ========================================================================== --

vim.g.mapleader = ' '

-- ========================================================================== --
-- 2. VIM OPTIONS (Editor Behavior)
-- ========================================================================== --

-- Line Numbers
vim.opt.number = true          -- Enable line numbers

-- Indentation & Tabs
vim.opt.tabstop = 4            -- Number of spaces that a <Tab> counts for
vim.opt.shiftwidth = 4         -- Number of spaces to use for each step of auto-indent
vim.opt.expandtab = true        -- Convert tabs to spaces

-- Window Splits Behavior
vim.opt.splitbelow = true      -- Force all horizontal splits to open below current window
vim.opt.splitright = true      -- Force all vertical splits to open to the right current window

-- Clipboard Integration
vim.opt.clipboard = 'unnamedplus' -- Yank saves directly to the system clipboard

-- Tabby save session and window layout when exiting
vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'

-- Force Neovim to use OSC 52 escape sequences for clipboard actions
-- vim.g.clipboard = {
--   name = 'OSC 52',
--   copy = {
--     ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
--     ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
--   },
--   -- paste = {
--   --   ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
--   --   ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
--   -- },
-- }

-- ========================================================================== --
-- 3. KEYMAPS (Shortcuts)
-- ========================================================================== --

-- General Editor Keymaps
vim.keymap.set('n', '<leader>e', ':Ex<CR>', { desc = 'Open File Explorer' })
vim.keymap.set('n', '<leader>qw', ':close<CR>', { desc = 'Close current split window' })
vim.keymap.set('n', '<Esc>', ':nohlsearch<CR><Esc>', { silent = true, desc = 'Clear search highlight' })

-- Tab Management
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', { desc = 'Open a new tab' })
vim.keymap.set('n', '<leader>tc', ':tabclose<CR>', { desc = 'Close current tab' })
vim.keymap.set('n', '<Tab>', ':tabnext<CR>', { desc = 'Go to next tab' })
vim.keymap.set('n', '<S-Tab>', ':tabprevious<CR>', { desc = 'Go to previous tab' })
vim.keymap.set('n', '<leader><Left>', ':tabmove -1<CR>', { silent = true, desc = 'Move tab left' })
vim.keymap.set('n', '<leader><Right>', ':tabmove +1<CR>', { silent = true, desc = 'Move tab right' })
vim.keymap.set('n', '<leader>tr', ':Tabby rename_tab ', { desc = 'Rename current tab' })

-- Window Navigation (Smart Mode Preservation)

-- 1. Moving from Normal mode: Just move windows cleanly
vim.keymap.set('n', '<M-Left>',  [[<Cmd>wincmd h<CR>]], { silent = true, desc = 'Move left' })
vim.keymap.set('n', '<M-Down>',  [[<Cmd>wincmd j<CR>]], { silent = true, desc = 'Move down' })
vim.keymap.set('n', '<M-Up>',    [[<Cmd>wincmd k<CR>]], { silent = true, desc = 'Move up' })
vim.keymap.set('n', '<M-Right>', [[<Cmd>wincmd l<CR>]], { silent = true, desc = 'Move right' })

-- 2. Moving from Insert mode: Drop back to Normal Mode when jumping code windows
vim.keymap.set('i', '<M-Left>',  [[<Esc><Cmd>wincmd h<CR>]], { silent = true, desc = 'Move left and drop to Normal' })
vim.keymap.set('i', '<M-Down>',  [[<Esc><Cmd>wincmd j<CR>]], { silent = true, desc = 'Move down and drop to Normal' })
vim.keymap.set('i', '<M-Up>',    [[<Esc><Cmd>wincmd k<CR>]], { silent = true, desc = 'Move up and drop to Normal' })
vim.keymap.set('i', '<M-Right>', [[<Esc><Cmd>wincmd l<CR>]], { silent = true, desc = 'Move right and drop to Normal' })


-- 3. Moving from Terminal mode: If target window is a terminal, stay in terminal mode
local function term_nav(dir)
  return function()
    vim.cmd('wincmd ' .. dir)
    -- Check if we landed in a terminal buffer
    if vim.bo.buftype == 'terminal' then
      vim.schedule(function()
        vim.cmd('startinsert')
      end)
    end
  end
end

vim.keymap.set('t', '<M-Left>',  term_nav('h'), { silent = true, desc = 'Move left from terminal' })
vim.keymap.set('t', '<M-Down>',  term_nav('j'), { silent = true, desc = 'Move down from terminal' })
vim.keymap.set('t', '<M-Up>',    term_nav('k'), { silent = true, desc = 'Move up from terminal' })
vim.keymap.set('t', '<M-Right>', term_nav('l'), { silent = true, desc = 'Move right from terminal' })

-- Window Layout Splitting (New shortcuts)
vim.keymap.set('n', '<leader>sh', ':split<CR>', { silent = true, desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>sv', ':vsplit<CR>', { silent = true, desc = 'Split window vertically' })

-- Terminal Shortcuts
vim.keymap.set('n', '<leader>tt', ':terminal<CR>', { silent = true, desc = 'Open terminal' })
vim.keymap.set('n', '<leader>th', ':split | terminal<CR>', { silent = true, desc = 'Open terminal (Horizontal Split)' })
vim.keymap.set('n', '<leader>tv', ':vsplit | terminal<CR>', { silent = true, desc = 'Open terminal (Vertical Split)' })
vim.keymap.set('t', '<Esc><Esc>', [[<C-\><C-n>]], { silent = true, desc = 'Exit terminal mode' })

-- Text Selection (Shift + Arrow keys in Insert Mode)
vim.keymap.set('i', '<S-Up>', '<Esc>v<Up>', { desc = 'Select text up' })
vim.keymap.set('i', '<S-Down>', '<Esc>v<Down>', { desc = 'Select text down' })
vim.keymap.set('i', '<S-Left>', '<Esc>v<Left>', { desc = 'Select text left' })
vim.keymap.set('i', '<S-Right>', '<Esc>v<Right>', { desc = 'Select text right' })

-- Language Specific Tools
vim.keymap.set('n', '<F5>', ':w<CR>:vsplit term://python3 %<CR>', { desc = 'Save and run Python file' })


-- Create a custom command to compare the active unsaved buffer with the file on disk
vim.api.nvim_create_user_command('DiffSaved', function()
  -- Get the current file type so syntax highlighting stays accurate
  local ft = vim.bo.filetype

  -- Open a vertical split, create a scratch buffer, and read the file from disk
  vim.cmd('vertical new')
  vim.cmd('set buftype=nofile bufhidden=wipe noswapfile')
  vim.cmd('read ++edit #')
  vim.cmd('0delete_') -- Clean up the empty first line read creates
  vim.cmd('setlocal readonly buftype=nofile filetype=' .. ft)

  -- Put both the original window and the new scratch window into diff mode
  vim.cmd('diffthis')
  vim.cmd('wincmd p')
  vim.cmd('diffthis')
end, {})

-- Bind it to a clean keymap (e.g., Space + s for "Save Diff")
vim.keymap.set('n', '<leader>s', '<cmd>DiffSaved<cr>', { desc = 'Diff current buffer with file on disk' })


-- ========================================================================== --
-- 4. AUTOCOMMANDS (Automation)
-- ========================================================================== --

-- Netrw Customization: Remap 'x' to execute a horizontal split ('o')
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'netrw',
  callback = function()
    vim.keymap.set('n', 'x', 'o', { remap = true, buffer = true, desc = 'Horizontal split in Netrw' })
  end,
})

-- Formatting: Delete trailing spaces automatically before saving
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function()
    local save_cursor = vim.fn.getpos('.')
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos('.', save_cursor)
  end,
})

-- ========================================================================== --
-- 5. PLUGIN CONFIGURATION (Lazy.nvim)
-- ========================================================================== --

require('config.lazy')

