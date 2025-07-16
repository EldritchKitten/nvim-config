return {
	{'folke/tokyonight.nvim'},
	{
		'williamboman/mason.nvim',
		version = "1.11.0",
	},
	{
		'williamboman/mason-lspconfig.nvim',
		version = "1.11.0",
	},
	{'neovim/nvim-lspconfig'},
	{'simrat39/rust-tools.nvim'}, -- Completion framework
	{'hrsh7th/nvim-cmp'}, -- LSP completion source
	{'hrsh7th/cmp-nvim-lsp'}, -- LSP completion source
	-- Useful completion sources:
	{'hrsh7th/cmp-nvim-lua'},
	{'hrsh7th/cmp-nvim-lsp-signature-help'},
	{'hrsh7th/cmp-vsnip'},
	{'hrsh7th/cmp-path'},
	{'hrsh7th/cmp-buffer'},
	{'hrsh7th/vim-vsnip'},
}

--return {
--  {'folke/tokyonight.nvim'},
--  {'neovim/nvim-lspconfig', tag = 'v1.8.0', pin = true},
--  {'hrsh7th/cmp-nvim-lsp'},
--  {'hrsh7th/nvim-cmp'},
--}
