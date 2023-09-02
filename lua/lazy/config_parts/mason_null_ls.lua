local mason = {
	"williamboman/mason.nvim",
	event = "VeryLazy",
	config = function()
		require("mason").setup()
	end,
}
local mason_null_ls = {
	"jay-babu/mason-null-ls.nvim",

	event = "VeryLazy",
	config = function()
		local langs_table = require("utils.langs_table")
		local null_ls = require("null-ls")
		for _, data in pairs(langs_table) do
			for type, null_ls_data in pairs(data.null_ls) do
				local sources = {}
				for _, val in pairs(null_ls_data) do
					local null_ls_builtin = null_ls.builtins[type][val.program]
					table.insert(sources, val.with and null_ls_builtin.with(val.with) or null_ls_builtin)
				end
				null_ls.register({ sources = sources })
			end
		end
	end,
	dependencies = { mason },
}

local null_ls = {
	"jose-elias-alvarez/null-ls.nvim",

	event = "VeryLazy",
	config = function()
		-- Languages setup
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				null_ls.builtins.completion.luasnip,
			},
			on_attach = require("lsp-format").on_attach,
		})
	end,
	dependencies = {
		mason_null_ls,
		{
			"lukas-reineke/lsp-format.nvim",
		},
		{ "jose-elias-alvarez/typescript.nvim" },
	},
}

return null_ls
