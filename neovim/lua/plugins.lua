require("lazy").setup({

  -- ============================================================
  -- UI / ファイラー / ステータスライン
  -- ============================================================
  { "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup()
      vim.keymap.set("n", "<C-n>n", ":NvimTreeToggle<CR>", { silent = true })
    end
  },
  { "itchyny/lightline.vim" },
  { "simeji/winresizer" },
  { "sjl/gundo.vim" },

  -- ============================================================
  -- Git
  -- ============================================================
  { "tpope/vim-fugitive" },
  { "rhysd/conflict-marker.vim" },

  -- ============================================================
  -- 編集補助
  -- ============================================================
  { "tpope/vim-surround" },
  { "tpope/vim-endwise" },
  { "cohama/lexima.vim" },
  { "ConradIrwin/vim-bracketed-paste" },
  { "numToStr/Comment.nvim", config = function() require("Comment").setup() end },
  { "vim-utils/vim-man" },

  -- ============================================================
  -- ファジーファインダー
  -- ============================================================
  { "junegunn/fzf",         build = "./install --bin" },
  { "ibhagwan/fzf-lua",     dependencies = { "nvim-tree/nvim-web-devicons" } },
  { "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function() require("telescope").setup() end
  },

  -- ============================================================
  -- Treesitter
  -- ============================================================
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- ============================================================
  -- LSP
  -- ============================================================
  { "neovim/nvim-lspconfig" },

  -- ============================================================
  -- 補完 (nvim-cmp)
  -- ============================================================
  { "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-vsnip",
      "hrsh7th/vim-vsnip",
      "hrsh7th/vim-vsnip-integ",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args) vim.fn["vsnip#anonymous"](args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<Tab>"]   = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
          ["<CR>"]    = cmp.mapping.confirm({ select = false }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "vsnip" },
        }),
      })
    end
  },

  -- ============================================================
  -- Linter
  -- ============================================================
  { "dense-analysis/ale",
    config = function()
      vim.g.ale_enable           = 1
      vim.g.ale_set_quickfix     = 0
      vim.g.ale_sign_column_always = 0
      vim.g.ale_lint_on_enter    = 1
      vim.g.ale_open_list        = 1
      vim.g.ale_keep_list_window_open = 0
      vim.g.ale_statusline_format = { "⨉ %d", "⚠ %d", "⬥ ok" }
      vim.g.ale_sign_error       = "⤫"
      vim.g.ale_sign_warning     = "⚠"
      vim.g.ale_linters          = { go = { "golint", "gobuild" } }
      vim.g.ale_fixers           = { ruby = { "rubocop" }, go = { "goimports" } }
      vim.g.ale_fix_on_save      = 0
    end
  },

  -- ============================================================
  -- DAP (デバッグ)
  -- ============================================================
  { "mfussenegger/nvim-dap" },
  { "rcarriga/nvim-dap-ui",  dependencies = { "mfussenegger/nvim-dap" } },
  { "leoluz/nvim-dap-go",
    ft = "go",
    config = function() require("dap-go").setup() end
  },
  { "sebdah/vim-delve", ft = "go" },

  -- ============================================================
  -- AI
  -- ============================================================
  { "github/copilot.vim" },
  { "nvim-lua/plenary.nvim" },

  -- ============================================================
  -- Markdown / プレビュー
  -- ============================================================
  { "kannokanno/previm" },
  { "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = "cd app && yarn install",
    init = function() vim.g.mkdp_browser = "Safari" end
  },

  -- ============================================================
  -- 言語サポート
  -- ============================================================
  -- Rust
  { "rust-lang/rust.vim",
    ft = "rust",
    init = function()
      vim.g.rustfmt_autosave = 1
      vim.g.rustfmt_command  = "$HOME/.cargo/bin/rustfmt"
    end
  },
  { "rhysd/rust-doc.vim", ft = "rust" },

  -- Go
  { "ctrlpvim/ctrlp.vim", ft = "go" },

  -- Ruby
  { "szw/vim-tags",       ft = "ruby" },
  { "tpope/vim-dispatch", ft = "ruby" },
  { "thoughtbot/vim-rspec",
    ft = "ruby",
    init = function() vim.g.rspec_command = "Dispatch rspec {spec}" end
  },

  -- Swift
  { "Keithbsmiley/swift.vim", ft = "swift" },

  -- JavaScript
  { "pangloss/vim-javascript", ft = { "javascript", "typescript" } },
  { "prettier/vim-prettier",
    build = "npm install",
    ft = { "javascript", "typescript", "vue", "css", "scss", "json", "markdown", "graphql" }
  },

  -- SuperCollider
  { "sbl/scvim",
    ft = { "supercollider", "sc", "scd" },
    init = function()
      vim.g.sclangPipeApp    = "~/.vim/bundle/scvim/bin/start_pipe"
      vim.g.sclangDispatcher = "~/.vim/bundle/scvim/bin/sc_dispatcher"
    end
  },
  { "munshkr/vim-tidal" },

  -- その他言語
  { "uarun/vim-protobuf",   ft = "proto" },
  { "hashivim/vim-terraform", ft = { "terraform", "tf" } },
  { "aklt/plantuml-syntax", ft = { "uml", "plantuml" } },
  { "cespare/vim-toml",     ft = "toml" },
  { "kana/vim-filetype-haskell", ft = "haskell" },
  { "dag/vim2hs",           ft = "haskell" },
  { "milch/vim-fastlane" },

  -- ============================================================
  -- ユーティリティ
  -- ============================================================
  { "thinca/vim-quickrun",
    config = function()
      vim.g.quickrun_config = { supercollider = { command = "'<,'>call SClang_send()" } }
    end
  },
  { "mattn/webapi-vim" },
  { "tell-k/vim-browsereload-mac" },
  { "nathanaelkane/vim-indent-guides",
    init = function()
      vim.g.indent_guides_enable_on_vim_startup = 0
      vim.g.indent_guides_start_level           = 2
      vim.g.indent_guides_auto_colors           = 0
      vim.g.indent_guides_guide_size            = 1
    end
  },
  { "thinca/vim-localrc" },
  { "vim-scripts/Spacegray.vim" },
  { "whatyouhide/vim-gotham" },
  { "hrsh7th/vim-vsnip" },
  { "hrsh7th/vim-vsnip-integ" },

}, {
  -- lazy.nvim オプション
  install = { colorscheme = { "spacegray" } },
  checker = { enabled = false },
})
