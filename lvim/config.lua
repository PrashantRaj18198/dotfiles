-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
--
--
local function log_message(message)
  local log_file = io.open(vim.fn.expand("~/.cache/nvim/path_log.log"), "a") -- Change the path if needed
  log_file:write(message .. "\n")
  log_file:close()
end

local function close_neo_tree()
  require 'neo-tree.sources.manager'.close_all()
  vim.notify('closed all')
end

local function open_neo_tree()
  vim.notify('opening neotree')
  require 'neo-tree.sources.manager'.show('filesystem')
end

vim.g.mapleader = " "
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

-- -- Automatically change the current working directory to the directory of the opened file
-- vim.cmd([[
--   augroup AutoChangeDirectory
--     autocmd!
--     autocmd BufEnter * silent! lcd %:p:h
--   augroup END
-- ]])

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
          position = "right",
          width = 30,
        },
        buffers = {
          follow_current_file = true,
        },
        filesystem = {
          follow_current_file = true,
          use_libuv_file_watcher = true,
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
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "luvit-meta/library", words = { "vim%.uv" } },
      },
    },
  },
  { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  {                                        -- optional completion source for require statements and module annotations
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0, -- set group index to 0 to skip loading LuaLS completions
      })
    end,
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
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } }, -- For the DAP UI
  { "leoluz/nvim-dap-go" },                                                                        -- For Go debugging support
  --- Session management
  {
    'rmagatti/auto-session',
    lazy = true,
    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
      -- log_level = 'debug',
      auto_session_create_enabled = false,
      auto_save_enabled = true,
      auto_restore_enabled = true,
      auto_session_use_git_branch = true,
      bypass_session_save_file_types = { "neo-tree" },
      pre_save_cmds = {
        close_neo_tree,
      },
      post_restore_cmds = {
        open_neo_tree,
      }
    }
  }
}

require("neodev").setup({
  library = { plugins = { "nvim-dap-ui" }, types = true },
})

--- *** DAP and its key maps *** ---
-- DAP Go setup
local dap_go = require("dap-go")
dap_go.setup()
-- DAP UI setup (optional but useful)
local dap = require('dap')
-- Keybindings for DAP (you can change these as needed)
lvim.builtin.dap.active = true
-- Keybindings for debugging
-- lvim.keys.normal_mode["<leader>dc"] = ":lua require('dap').continue()<CR>"
-- lvim.keys.normal_mode["<leader>db"] = ":lua require('dap').toggle_breakpoint()<CR>"
-- lvim.keys.normal_mode["<leader>di"] = ":lua require('dap').step_into()<CR>"
-- lvim.keys.normal_mode["<leader>do"] = ":lua require('dap').step_over()<CR>"
-- lvim.keys.normal_mode["<leader>du"] = ":lua require('dapui').toggle()<CR>" -- For toggling the DAP UI
-- DAP keybindings
vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Start/Continue Debugging" })
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step Into" })
vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step Over" })
vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step Out" })
vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "Restart Debugger" })
vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "Terminate Debugger" })

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

--- Terminal stuff ---
-- Table to keep track of terminal buffers
local terminal_buffers = {}

-- Function to open or switch to a terminal buffer
local function open_or_switch_to_terminal(term_num)
  -- If the terminal buffer exists and is loaded, switch to it
  if terminal_buffers[term_num] and vim.api.nvim_buf_is_loaded(terminal_buffers[term_num]) then
    vim.api.nvim_set_current_buf(terminal_buffers[term_num])
  else
    -- Otherwise, create a new terminal buffer
    if term_num == 1 then
      vim.cmd("split | terminal")
    elseif term_num == 2 then
      vim.cmd("vsplit | terminal")
    elseif term_num == 3 then
      vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, {
        relative = "editor",
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
        row = math.floor(vim.o.lines * 0.1),
        col = math.floor(vim.o.columns * 0.1),
        style = "minimal",
        border = "rounded"
      })
      vim.cmd("terminal")
    end
    -- Store the buffer number in the table
    terminal_buffers[term_num] = vim.api.nvim_get_current_buf()
  end
end

-- Keybindings to open or switch to terminal 1
vim.keymap.set("n", "<leader>t1", function() open_or_switch_to_terminal(1) end, { desc = "Open/Switch to Terminal 1" })

-- Keybindings to open or switch to terminal 2
vim.keymap.set("n", "<leader>t2", function() open_or_switch_to_terminal(2) end, { desc = "Open/Switch to Terminal 2" })

-- Keybindings to open or switch to terminal 3
vim.keymap.set("n", "<leader>t3", function() open_or_switch_to_terminal(3) end, { desc = "Open/Switch to Terminal 3" })

-- Keybinding to close the current terminal buffer
vim.keymap.set("n", "<leader>tc", ":bdelete!<CR>", { desc = "Close Current Terminal" })

-- Quickly exit terminal mode back to normal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit Terminal Mode" })


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

-- Log the current working directory
local cwd = vim.fn.getcwd()
log_message("Current Working Directory (cwd): " .. cwd)
-- Check and load project-specific DAP configuration if it exists
local project_dap_config = vim.fn.getcwd() .. "/.nvim/dap_config.lua"
if vim.fn.filereadable(project_dap_config) == 1 then
  print("Loading project-specific DAP config from: " .. project_dap_config)
  log_message("Loading project-specific DAP config from: " .. project_dap_config)
  dofile(project_dap_config)
else
  print("No project-specific DAP config found at: " .. project_dap_config)
  log_message("No project-specific DAP config found at: " .. project_dap_config)
end

-- Ensure dapui is set up after loading DAP configurations
require('dapui').setup()
local dapui = require('dapui')

-- Automatically open DAP UI when debugging starts
-- DAP UI keybindings
vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle DAP UI" })
