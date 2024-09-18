-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

-- lvim.leader = "g"
lvim.plugins = {
  {
    'projekt0n/github-nvim-theme',
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('github-theme').setup({
        -- ...
      })

      vim.cmd('colorscheme github_dark')
    end,
  },
  {
    'wfxr/minimap.vim',
    build = "cargo install --locked code-minimap",
    -- cmd = {"Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight"},
    config = function()
      vim.cmd("let g:minimap_width = 10")
      vim.cmd("let g:minimap_auto_start = 1")
      vim.cmd("let g:minimap_auto_start_win_enter = 1")
    end,
  },
  {
    "lepture/vim-jinja",
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        window = {
          width = 30,
        },
        buffers = {
          follow_current_file = true,
        },
        filesystem = {
          follow_current_file = true,
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
            hide_by_name = {
              "node_modules"
            },
            never_show = {
              ".DS_Store",
              "thumbs.db"
            },
          },
        },
      })
    end
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {}
  },
  -- {
  --   "ruifm/gitlinker.nvim",
  --   event = "BufRead",
  --   config = function()
  --     require("gitlinker").setup {
  --       opts = {
  --         -- remote = 'github', -- force the use of a specific remote
  --         -- adds current line nr in the url for normal mode
  --         add_current_line_on_normal_mode = true,
  --         -- callback for what to do with the url
  --         action_callback = require("gitlinker.actions").open_in_browser,
  --         -- print the url after performing the action
  --         print_url = false,
  --         -- mapping to call url generation
  --         mappings = "<leader>gy",
  --       },
  --     }
  --   end,
  --   dependencies = "nvim-lua/plenary.nvim",
  -- },
  {
    "f-person/git-blame.nvim",
    event = "BufRead",
    config = function()
      vim.cmd "highlight default link gitblame SpecialComment"
      require("gitblame").setup {
        enabled = true,
        date_format = '%r',
      }
    end,
  },
  -- {
  --   "sindrets/diffview.nvim",
  --   event = "BufRead",
  -- }
  --
  -- DAP plugins
  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui" }, -- For the DAP UI
  { "leoluz/nvim-dap-go" },   -- For Go debugging support

}

--- *** DAP and its key maps *** ---
-- DAP Go setup
local dap_go = require("dap-go")
dap_go.setup()
-- DAP UI setup (optional but useful)
local dap_ui = require("dapui")
local dap = require('dap')
dap_ui.setup()
-- Keybindings for DAP (you can change these as needed)
lvim.builtin.dap.active = true
-- Keybindings for debugging
lvim.keys.normal_mode["<leader>dc"] = ":lua require'dap'.continue()<CR>"
lvim.keys.normal_mode["<leader>db"] = ":lua require'dap'.toggle_breakpoint()<CR>"
lvim.keys.normal_mode["<leader>di"] = ":lua require'dap'.step_into()<CR>"
lvim.keys.normal_mode["<leader>do"] = ":lua require'dap'.step_over()<CR>"
lvim.keys.normal_mode["<leader>du"] = ":lua require'dapui'.toggle()<CR>" -- For toggling the DAP UI

-- Load project-specific DAP configuration
local project_dap_config = vim.fn.getcwd() .. "/.nvim/dap_config.lua"
if vim.fn.filereadable(project_dap_config) == 1 then
  dofile(project_dap_config)
end

dap.set_log_level('TRACE')

dap.configurations.go = {
  {
    name = "Debug WarpBuild",
    type = "go",
    request = "launch",
    program = "${workspaceFolder}/main.go",
    mode = "auto",
    dlvToolPath = vim.fn.exepath("dlv"), -- Ensure dlv is installed
  },
  {
    name = "Debug Migrations",
    type = "go",
    request = "launch",
    program = "${workspaceFolder}/migrations/main.go",
    mode = "auto",
    cwd = "${workspaceFolder}",
    args = { "" },
    showLog = true,
  },
  {
    name = "Debug Workflows Refresher",
    type = "go",
    request = "launch",
    program = "${workspaceFolder}/cmd/workflowsrefresher/main.go",
    mode = "auto",
    cwd = "${workspaceFolder}",
    args = {},
  },
}

lvim.builtin.nvimtree.active = false

-- *** KEY REMAPS *** ---

lvim.builtin.terminal.open_mapping = "<c-t>"

-- Override existing `gI` keybinding with `gi` for Go to Implementation
lvim.lsp.buffer_mappings.normal_mode['gi'] = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Go to Implementation" }

-- Optionally remove or remap the `gI` keybinding
lvim.lsp.buffer_mappings.normal_mode['gI'] = nil -- Removes the gI keybindingk

-- Remap LSP hover action from 'K' to 'gh'
lvim.lsp.buffer_mappings.normal_mode['gh'] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "LSP Hover" }

-- Optionally, remove the default 'K' binding
lvim.lsp.buffer_mappings.normal_mode['K'] = nil -- Remove this if you don't want 'K' to trigger hover

-- Remap <leader><leader> to save the current file
lvim.keys.normal_mode["<leader><leader>"] = ":w<CR>"

lvim.keys.normal_mode["gw"] = "<Cmd>BufferKill<CR>"

-- Map <leader>e to toggle and navigate to Neo-tree
lvim.keys.normal_mode["<leader>e"] = ":Neotree focus<CR>"

-- Comment toggle using Ctrl+/ in Insert mode
lvim.keys.insert_mode["<C-/>"] = "<esc><cmd>lua require('Comment.api').toggle.linewise.current()<CR>a"

-- Go to the next diagnostic (error, warning, etc.)
lvim.keys.normal_mode["]d"] = "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>"

-- Go to the previous diagnostic (error, warning, etc.)
lvim.keys.normal_mode["[d"] = "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>"

--- *** File type associations *** ---
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.j2", "*.jinja", "*.jinja2" },
  command = "set filetype=jinja",
})

--- *** LSP *** ---
--
-- Auto-reload the Go LSP when `go.mod` or `go.sum` is modified
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  pattern = { "go.mod", "go.sum" },
  callback = function()
    -- Notify user about the LSP reload and reload the LSP for Go
    vim.lsp.stop_client(vim.lsp.get_active_clients(), true)
    vim.cmd("edit") -- Re-open the buffer to reinitialize the LSP
    print("Go LSP reloaded after updating go.mod or go.sum")
  end,
})

--- *** Formatters *** ---
--
-- Set up LSP formatting for Go to use goimports
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  {
    command = "goimports",
    filetypes = { "go" },
  },
}

-- Enable format on save
lvim.format_on_save.enabled = true
