vim.g.mapleader = " "

vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.signcolumn = "yes"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.mouse = ""

vim.lsp.config("rust_analyzer", {
    cmd = { "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml", "Cargo.lock", ".git" },
    before_init = function(_, config)
        local root = config.root_dir
        local found = vim.fn.glob(root .. "/*/Cargo.toml", true, true)
        table.insert(found, root .. "/Cargo.toml")
        config.settings["rust-analyzer"].linkedProjects = found
    end,
    settings = {
        ["rust-analyzer"] = {
            cargo = { features = "all" },
            check = { command = "clippy" },
            completion = {
                autoimport = { enable = true },
                callable = { snippets = "fill_arguments" },
            },
            import = {
                granularity = { enforce = true, group = "module" },
                prefix = "crate",
            }
        },
    },   
})
if not vim.g.no_lsp then
    vim.lsp.enable("rust_analyzer")
end

vim.diagnostic.config({ virtual_text = true, virtual_lines = false })

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.rs",
    callback = function() vim.lsp.buf.format() end,
})

vim.pack.add({
    { src = "https://github.com/rose-pine/neovim", name = "rose-pine" },
    { src = "https://github.com/nvim-lua/plenary.nvim" },
    { src = "https://github.com/nvim-telescope/telescope.nvim" },
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    { src = "https://github.com/tpope/vim-fugitive" },
    { src = "https://github.com/lewis6991/gitsigns.nvim" },
    { src = "https://github.com/folke/flash.nvim" },
    { src = "https://github.com/nvim-mini/mini.statusline" },
    { src = "https://github.com/nvim-mini/mini.icons" },
    { src = "https://github.com/mikavilpas/yazi.nvim" },
    { src = "https://github.com/lewis6991/satellite.nvim" },
})

require("nvim-treesitter").install({ "rust", "toml", "lua", "markdown", "wit", "nix" })

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "rust", "toml", "lua", "markdown", "wit", "nix" },
    callback = function()
        pcall(vim.treesitter.start)
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

vim.filetype.add({ extension = { wit = "wit" } })

vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.o.foldmethod = "expr"
vim.o.foldlevel = 99

require("blink.cmp").setup({
    keymap = { preset = "default" },
    completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        accept = { auto_brackets = { enabled = true } },
    },
    sources = { default = { "lsp", "path", "snippets", "buffer" } },
})

require("rose-pine").setup({
    variant = "auto",
    dark_variant = "main",
    styles = {
        bold = true,
        italic = true,
        transparency = true
    },
    groups = {
        git_add = "#4ade80",
        git_change = "#facc15",
        git_delete = "#f87171",
    },
})
vim.o.termguicolors = true
vim.o.background = "dark"
vim.cmd.colorscheme("rose-pine")

local actions = require("telescope.actions")

require("telescope").setup({
    defaults = {
        file_ignore_patterns = { "^.git/", "^target/" },
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        scroll_strategy = "limit",
        mappings = {
            i = {
                ["<esc>"] = actions.close,
                ["<C-d>"] = actions.results_scrolling_down,
                ["<C-u>"] = actions.results_scrolling_up,
                ["<C-f>"] = actions.preview_scrolling_down,
                ["<C-b>"] = actions.preview_scrolling_up,
            },
        },
    },
    pickers = {
        find_files = { hidden = true },
    },
})

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.live_grep)
vim.keymap.set("n", "<leader>fb", builtin.buffers)
vim.keymap.set("n", "<leader>fh", builtin.help_tags)
vim.keymap.set("n", "<leader>fd", builtin.diagnostics)
vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols)
vim.keymap.set("n", "gr", builtin.lsp_references)

require("gitsigns").setup({
    signs = {
        add          = { text = "▌" },
        change       = { text = "▌" },
        delete       = { text = "▁" },
        topdelete    = { text = "▔" },
        changedelete = { text = "▌" },
    },
    signs_staged = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "▁" },
        topdelete    = { text = "▔" },
        changedelete = { text = "▎" },
    },
    current_line_blame = false,
    signcolumn = true,
    word_diff = false,
})

local gs = require("gitsigns")
vim.keymap.set("n", "]c", gs.next_hunk)
vim.keymap.set("n", "[c", gs.prev_hunk)
vim.keymap.set("n", "<leader>hp", gs.preview_hunk_inline)
vim.keymap.set("n", "<leader>hb", gs.toggle_current_line_blame)
vim.keymap.set("n", "<leader>hv", "<cmd>Gvdiffsplit<cr>")

require("satellite").setup({
    current_only = false,
    winblend = 50,
    zindex = 40,
    width = 2,
    excluded_filetypes = { "TelescopePrompt", "yazi", "help", "qf", "fugitive" },
    handlers = {
        cursor     = { enable = true },
        search     = { enable = true },
        diagnostic = {
            enable = true,
            min_severity = vim.diagnostic.severity.HINT,
        },
        gitsigns = {
            enable = true,
            signs = { add = "│", change = "│", delete = "-" },
        },
        marks    = { enable = true, show_builtins = false },
        quickfix = { enable = true },
    },
})
require("flash").setup()

vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end)
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end)

require("mini.icons").setup()
require("mini.statusline").setup({
    use_icons = true,
    content = {
        active = function()
            local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
            local git         = MiniStatusline.section_git({ trunc_width = 40, icon = "" })
            local filename    = MiniStatusline.is_truncated(140) and "%t%m%r" or "%f%m%r"
            local search      = MiniStatusline.section_searchcount({ trunc_width = 75 })

            local progress = ""
            if LspProgressStatus and LspProgressStatus ~= "" then
                progress = "󰔟 " .. LspProgressStatus:gsub("%%", "%%%%")
            end

            local encoding = vim.bo.fileencoding
            if encoding == "" then encoding = vim.o.encoding end
            local fileinfo = vim.bo.filetype
            if fileinfo ~= "" then
                fileinfo = fileinfo .. " " .. encoding
            else
                fileinfo = encoding
            end

            local location = "%l:%v"

            return MiniStatusline.combine_groups({
                { hl = mode_hl,                  strings = { mode } },
                { hl = "MiniStatuslineDevinfo",  strings = { git } },
                "%<",
                { hl = "MiniStatuslineFilename", strings = { filename } },
                "%=",
                { hl = "MiniStatuslineDevinfo",  strings = { progress } },
                { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
                { hl = mode_hl,                  strings = { search, location } },
            })
        end,
    },
})
vim.o.laststatus = 3
vim.api.nvim_create_autocmd("LspProgress", {
    callback = function(ev)
        local v = ev.data.params.value
        if v.kind == "end" then
            LspProgressStatus = ""
        else
            local pct = v.percentage and (" " .. v.percentage .. "%") or ""
            LspProgressStatus = (v.title or "") .. pct
        end
        vim.cmd.redrawstatus()
    end,
})

require("yazi").setup({
    open_for_directories = false,
    keymaps = { show_help = "<f1>" },
    yazi_floating_window_border = "none",
})

vim.keymap.set({ "n", "v" }, "<leader>-", "<cmd>Yazi<cr>")
vim.keymap.set("n", "<leader>cw", "<cmd>Yazi cwd<cr>")
-- vim.keymap.set("n", "<C-Up>", "<cmd>Yazi toggle<cr>")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p')
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P')

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<C-Up>",    "<cmd>resize +2<cr>")
vim.keymap.set("n", "<C-Down>",  "<cmd>resize -2<cr>")
vim.keymap.set("n", "<C-Left>",  "<cmd>vertical resize -2<cr>")
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<cr>")

