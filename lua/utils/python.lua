local M = {}

M.get_poetry_python_path = function()
    local handle = io.popen("poetry env info --path 2>/dev/null")
    if handle then
        local venv_path = handle:read("*a"):gsub("\n", "")
        handle:close()
        if venv_path and venv_path ~= "" then
            return venv_path .. "/bin/python"
        end
    end
    return vim.fn.exepath("python3") or "/usr/bin/python3"
end

return M
