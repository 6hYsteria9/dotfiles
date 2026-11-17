vim.opt.termguicolors = true
vim.opt.background = "dark"
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

local colors = {
    bg = "#232a2e",
    bg_subtle = "#2d353b",
    bg_highlight = "#343f44",
    fg = "#d3c6aa",
    fg_dim = "#859289",
    green = "#a7c080",
    aqua = "#83c092",
    blue = "#7fbbb3",
    yellow = "#dbbc7f",
    orange = "#e69875",
    red = "#e67e80",
    purple = "#d699b6",
}

local hl = function(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

hl("Normal", { fg = colors.fg, bg = colors.bg })
hl("NormalFloat", { fg = colors.fg, bg = colors.bg_subtle })
hl("FloatBorder", { fg = colors.green, bg = colors.bg })
hl("CursorLine", { bg = colors.bg_subtle })
hl("CursorLineNr", { fg = colors.green, bold = true })
hl("LineNr", { fg = colors.fg_dim })
hl("Visual", { bg = colors.bg_highlight })
hl("Search", { fg = colors.bg, bg = colors.yellow })
hl("IncSearch", { fg = colors.bg, bg = colors.orange })
hl("StatusLine", { fg = colors.fg, bg = colors.bg_subtle })
