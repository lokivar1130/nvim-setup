return {
    "mfussenegger/nvim-dap",
    dependencies = {
        -- Creates a beautiful debugger UI
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",

        -- Installs the debug adapters for you
        "williamboman/mason.nvim",
        "jay-babu/mason-nvim-dap.nvim",

        -- Add your own debuggers here
        "leoluz/nvim-dap-go",
        "mfussenegger/nvim-dap-python",
    },
    config = function()
        local dap = require("dap")
        local dapui = require("dapui")
        local mason_nvim_dap = require("mason-nvim-dap")
        local dap_python = require("dap-python")
        local utils = require("utils.python") -- Replace with actual module name

        mason_nvim_dap.setup({
            automatic_setup = true,
            automatic_installation = true,
            handlers = {},
            ensure_installed = {
                "python",
            },
        })

        -- For more information, see |:help nvim-dap-ui|
        dapui.setup({
            icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
            controls = {
                icons = {
                    pause = "⏸",
                    play = "▶",
                    step_into = "⏎",
                    step_over = "⏭",
                    step_out = "⏮",
                    step_back = "b",
                    run_last = "▶▶",
                    terminate = "⏹",
                    disconnect = "⏏",
                },
            },
        })
        dap.adapters.python = {
            type = "server",
            host = "127.0.0.1",
            port = 5678, -- Same port as debugpy
        }

        dap.configurations.python = {
            {
                type = "python",
                request = "launch",
                name = "Launch Python Module with Debugpy",
                module = function()
                    local main_py = vim.fn.glob("**/__main__.py")
                    if main_py ~= "" then
                        return main_py:match("([^/]+)/__main__.py$") or vim.fn.input("Enter Python module to debug: ")
                    end
                    return vim.fn.input("Enter Python module to debug: ")
                end,
                justMyCode = false,
                console = "integratedTerminal",
            },
            {
                type = "python",
                request = "attach",
                connect = {
                    host = "127.0.0.1",
                    port = 5678,
                },
                mode = "remote",
                name = "Attach to Running Python Process",
            },
        }

        vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "Debug: See last session result." })

        dap.listeners.after.event_initialized["dapui_config"] = dapui.open
        dap.listeners.before.event_terminated["dapui_config"] = dapui.close
        dap.listeners.before.event_exited["dapui_config"] = dapui.close
        dap_python.setup(utils.get_poetry_python_path())

        vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: Start/Continue" })
        vim.keymap.set("n", "<leader>dq", function()
            dap.terminate()
        end, { desc = "Debug: Stop debugging" })
        vim.keymap.set("n", "<leader>dsi", dap.step_into, { desc = "Debug: Step Into" })
        vim.keymap.set("n", "<leader>dso", dap.step_over, { desc = "Debug: Step Over" })
        vim.keymap.set("n", "<leader>dsv", dap.step_out, { desc = "Debug: Step Out" })
        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
        vim.keymap.set("n", "<leader>dB", function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end, { desc = "Debug: Set Breakpoint" })
    end,
}
