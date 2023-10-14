local M = {}

M.init = function()
	require("dapui").setup()
	local dap, dapui = require("dap"), require("dapui")

	local langs = require("utils.langs_table")

	for k, v in pairs(langs) do
		if v.dap == nil then
			goto continue
		end
		::continue::
	end

	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	end

	vim.keymap.set({ "n" }, "<leader>be", dap.terminate, { desc = "De[b]ug t[e]rminate" })
end

M.config = {
	"rcarriga/nvim-dap-ui",
	keys = {
		{
			"<leader>bc",
			"<cmd>DapContinue<CR>",
			desc = "De[b]ug [c]ontinue",
			mode = "n",
		},

		{
			"<leader>bd",
			"<cmd>DapToggleBreakpoint<CR>",
			desc = "Toggle [d]ebug breakpoint",
			mode = "n",
		},
	},
	dependencies = {
		{
			"mfussenegger/nvim-dap",
			dependencies = {
				{
					"jay-babu/mason-nvim-dap.nvim",
					event = "VeryLazy",
					config = function()
						local langs = require("utils.langs_table")
						local vals_with_dap = {}
						for _, v in pairs(langs) do
							if v.dap ~= nil then
								table.insert(vals_with_dap, v.dap.mason)
							end
						end
						require("mason-nvim-dap").setup({
							ensure_installed = vim.tbl_flatten(vals_with_dap),
							automatic_installation = true,
							handlers = {},
						})
					end,
				},
			},
			config = function()
				M.init()
			end,
		},
	},
}

return M
