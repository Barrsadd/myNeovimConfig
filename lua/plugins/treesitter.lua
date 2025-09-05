return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"windwp/nvim-ts-autotag",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				-- aktivin syntax highligthing
				highlight = { enable = true },

				-- aktivin indentasi
				indent = { enable = true },

				-- all about text objects
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.outer",
						}
					},
					move = {
						move = true,
						set_jumps = true,
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						}
					}
				},

				-- parser yang harus diinstall
				ensure_installed = {
					"html",
					"javascript",
					"typescript",
					"tsx",
					"vue",
					"lua",
					"markdown",
					"cpp",
                    "python"
				},
			})
		end
	},
}
