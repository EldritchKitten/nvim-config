require("config.lazy")
require("opts")


-- Appearance customization

vim.cmd.colorscheme("tokyonight") -- use color scheme from plugin


local switch_to_absolute_numbering = function()
	vim.opt.number = true
	vim.opt.relativenumber = false
end
local switch_to_relative_numbering = function()
	vim.opt.number = false
	vim.opt.relativenumber = true
end

switch_to_relative_numbering()

vim.api.nvim_create_autocmd({ "InsertEnter" }, {
	callback = function()
		-- vim.api.nvim_get_hl_by_name()
		local current = vim.api.nvim_get_hl(0, { name = "Normal" }).bg
		print(vim.inspect(current))
		
		local raisin_black = '#222436' -- default
		local dark_purple = '#221627'
		local chocolate_cosmos = '#480A0F'
		local black_bean = '#36070B'

		local new = dark_purple
		vim.api.nvim_set_hl(0, "Normal", {bg=new}) -- TODO - change the highlight based on the existing color scheme
		
		vim.opt.cursorline = true -- start highlighting cursor line
		switch_to_absolute_numbering()
	end
})
vim.api.nvim_create_autocmd({ "InsertLeave" }, {
	callback = function()
		vim.api.nvim_set_hl(0, "Normal", {bg="#222436"})
		vim.opt.cursorline = false -- stop highlighting cursor line
		switch_to_relative_numbering()
	end
})


-- Editor modes for setting keymaps
local normal_mode = 'n'
local normal_and_visual_mode = {'n', 'x'}

-- Unremapped keymaps
local cursor_to_line_start = '^'
local cursor_to_screen_bottom = 'L'
local cursor_to_screen_top = 'H'
local cursor_to_line_end = '$'

-- Keymaps - Leader Key
vim.g.mapleader = " "

-- Keymaps - Cursor Movement
vim.keymap.set(normal_and_visual_mode, 'H', cursor_to_line_start)
vim.keymap.set(normal_and_visual_mode, 'J', cursor_to_screen_bottom)
vim.keymap.set(normal_and_visual_mode, 'K', cursor_to_screen_top)
vim.keymap.set(normal_and_visual_mode, 'L', cursor_to_line_end)

-- Keymaps - Disable Arrow Keys (to force hjkl practice)
local bonk = function()
	vim.notify("BONK", vim.log.levels.WARN)
end
vim.keymap.set(normal_and_visual_mode, '<Up>', bonk)
vim.keymap.set(normal_and_visual_mode, '<Down>', bonk)
vim.keymap.set(normal_and_visual_mode, '<Left>', bonk)
vim.keymap.set(normal_and_visual_mode, '<Right>', bonk)

-- vim.api.nvim_out_write("Hello, this is a message!\n")

-- Keymaps - Screen Movement
vim.keymap.set(normal_and_visual_mode, 'Z', 'zz') -- For more convenient combing with J and K. Note this erases the default mapping ZZ to exit vim.

-- Keymaps - Insert new lines without entering insert mode
vim.keymap.set(normal_mode, '<Leader>o', 'o<Esc>k'..cursor_to_line_end)
vim.keymap.set(normal_mode, '<Leader>O', 'O<Esc>j'..cursor_to_line_start)

-- Keymaps - Tabs
vim.keymap.set(normal_and_visual_mode, '<tab><tab>', ':tabnew .<enter>')
vim.keymap.set(normal_and_visual_mode, '<tab>h', 'gT')
vim.keymap.set(normal_and_visual_mode, '<tab>l', 'gt')
vim.keymap.set(normal_and_visual_mode, '<tab>1', '1gt')
vim.keymap.set(normal_and_visual_mode, '<tab>2', '2gt')
vim.keymap.set(normal_and_visual_mode, '<tab>3', '3gt')
vim.keymap.set(normal_and_visual_mode, '<tab>4', '4gt')
vim.keymap.set(normal_and_visual_mode, '<tab>5', '5gt')
vim.keymap.set(normal_and_visual_mode, '<tab>6', '6gt')
vim.keymap.set(normal_and_visual_mode, '<tab>7', '7gt')
vim.keymap.set(normal_and_visual_mode, '<tab>8', '8gt')

-- Keymaps - Commands
vim.keymap.set(normal_and_visual_mode, '<leader>r', ':! gnome-terminal -- bash -c "cargo run; exec bash"<Enter>')
vim.keymap.set(normal_and_visual_mode, '<leader>g', ':! gnome-terminal -- bash -c "git status; exec bash"<Enter>')

-- Keymaps - Escape search highlighting
vim.keymap.set(normal_and_visual_mode, '<Esc><Esc>', ':noh<Enter>')


-- LSP Diagnostics Options Setup 
local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = '⚠️'})
sign({name = 'DiagnosticSignWarn', text = '❗'})
sign({name = 'DiagnosticSignHint', text = '👉'})
sign({name = 'DiagnosticSignInfo', text = '💡'})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = '',
    },
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

-- Completion Plugin Setup
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-S-f>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },
  -- Installed sources:
  sources = {
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
    { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer', keyword_length = 2 },        -- source current buffer
    { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
    { name = 'calc'},                               -- source for math calculation
  },
  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
              nvim_lsp = 'λ',
              vsnip = '⋗',
              buffer = 'Ω',
              path = '🖫',
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
})


