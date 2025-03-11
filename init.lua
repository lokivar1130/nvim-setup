local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)
vim.cmd("set number")
require("vim-options")
require("lazy").setup("plugins")
local handle = io.popen("poetry env info -p 2> /dev/null")
if handle then
    local poetry_env = handle:read("*a"):gsub("%s+", "")
    handle:close()
    if poetry_env and poetry_env ~= "" then
        vim.g.python3_host_prog = poetry_env .. "/bin/python"
    end
end
