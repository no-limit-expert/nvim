return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "williamboman/mason.nvim", config = true },
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
      -- 1. Global diagnostic look and keymaps
      vim.keymap.set('n', '<space>dp', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic' })
      vim.keymap.set('n', '<space>dn', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic' })
      vim.keymap.set('n', '<space>dd', vim.diagnostic.open_float, { desc = 'Open diagnostic floating window' })

      -- 2. Buffer-local LSP keymaps
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(event)
          local opts = { buffer = event.buf }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
          vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
          vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        end,
      })

      -- 3. Define the language servers for Python, YAML, JSON, and Lua
      local servers = {
        -- Lua
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = { globals = { 'vim' } },
              workspace = { checkThirdParty = false },
            },
          },
        },
        -- Python
        pyright = {},
        -- YAML
        -- yamlls = {},
        -- JSON
        -- jsonls = {},
      }

      -- 4. Tell mason-tool-installer to download these servers
      require('mason-tool-installer').setup({
        ensure_installed = vim.tbl_keys(servers),
      })

      -- 5. Pass individual server settings to lspconfig configurations
      for server_name, server_config in pairs(servers) do
        if next(server_config) ~= nil then
          vim.lsp.config(server_name, server_config)
        end
      end

      -- 6. Automatically enable your installed servers
      require('mason-lspconfig').setup({
        automatic_enable = true,
      })
    end,
  },
}

