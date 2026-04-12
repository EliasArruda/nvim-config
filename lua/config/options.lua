local venv = vim.fn.getcwd() .. "/.venv"
vim.g.lazyvim_python_lsp = "pyright"
vim.g.lazyvim_python_ruff = "ruff"
vim.opt.spell = true
vim.opt.spelllang = { "pt_br", "en" }
vim.env.VIRTUAL_ENV = venv
vim.env.PATH = venv .. "/bin:" .. vim.env.PATH
vim.g.autoformat = false
