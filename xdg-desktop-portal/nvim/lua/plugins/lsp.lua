return {
    -- 1. Mason (Downloads the language servers)
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },

    -- 2. Mason-LSPConfig (Bridges Mason with Neovim's LSP)
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                -- Tell Mason to ensure these are always installed!
                ensure_installed = { "lua_ls", "clangd", "rust_analyzer", "pylsp" },
            })
        end,
    },

    -- 3. Nvim-LSPConfig & Autocomplete (The actual Brain and Popup Menu)
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/nvim-cmp",         -- The completion plugin
            "hrsh7th/cmp-nvim-lsp",     -- Tells the completion plugin to talk to LSP
            "L3MON4D3/LuaSnip",         -- Snippet engine (required for nvim-cmp)
        },
        config = function()
            local cmp = require("cmp")
            local cmp_lsp = require("cmp_nvim_lsp")

            -- This tells the LSP servers what capabilities your autocomplete menu has
            local capabilities = cmp_lsp.default_capabilities()

            -- Setup the specific language servers (Neovim 0.11+ Syntax)
            
            -- C/C++
            vim.lsp.config.clangd = { capabilities = capabilities }
            vim.lsp.enable("clangd")

            -- Rust
            vim.lsp.config.rust_analyzer = { capabilities = capabilities }
            vim.lsp.enable("rust_analyzer")

            -- Python
            vim.lsp.config.pylsp = { capabilities = capabilities }
            vim.lsp.enable("pylsp")

            -- Lua
            vim.lsp.config.lua_ls = {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = { globals = { "vim" } } -- Stops Lua from complaining that 'vim' is undefined
                    }
                }
            }
            vim.lsp.enable("lua_ls")

            -- Configure the Autocomplete Menu
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-Space>'] = cmp.mapping.complete(), -- Press Ctrl+Space to manually open menu
                    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Press Enter to confirm selection
                    ['<Tab>'] = cmp.mapping.select_next_item(), -- Tab to go down
                    ['<S-Tab>'] = cmp.mapping.select_prev_item(), -- Shift+Tab to go up
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' }, -- Pull suggestions from the Language Server
                })
            })
        end
    }
}
