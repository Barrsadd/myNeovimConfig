return {
	"neovim/nvim-lspconfig",
	dependencies = {
		'williamboman/mason.nvim',
		'williamboman/mason-lspconfig.nvim',
		'hrsh7th/nvim-cmp',
		'hrsh7th/cmp-nvim-lsp',
		'hrsh7th/cmp-buffer',
		'hrsh7th/cmp-path',
		'L3MON4D3/LuaSnip',
		'saadparwaiz1/cmp_luasnip',
		'windwp/nvim-autopairs',
	},
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		-- performance optimizations
		vim.lsp.set_log_level("ERROR")

		vim.diagnostic.config({
			underline = true,
			virtual_text = false,
			signs = true,
			float = { border = 'rounded' },
			update_in_insert = false,
			severity_sort = true,
		})

		-- add cmp_nvim_lsp
		local lspconfig_defaults = require("lspconfig").util.default_config
		lspconfig_defaults.capabilities = vim.tbl_deep_extend(
			"force",
			lspconfig_defaults.capabilities,
			require("cmp_nvim_lsp").default_capabilities()
		)

		vim.api.nvim_create_autocmd('LspAttach', {
			callback = function(event)
				local opts = { buffer = event.buf }
				vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
				vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
				vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
				vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
				vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
				vim.keymap.set({ 'n', 'v' }, '<F3>', vim.lsp.buf.code_action, opts)
				vim.keymap.set('n', '<F4>', function()
					vim.lsp.buf.format({ async = true })
				end, opts)
				vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
				vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
				vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
			end
		})

		-- mason setup
		require('mason').setup({
			max_concurrent_installers = 1,
		})

		-- mason lspconfig
		require('mason-lspconfig').setup({
			ensure_installed = {
				"lua_ls",
				"ts_ls",
				"cssls",
				"html",
				"jsonls",
				"bashls",
				"clangd",
                "pyright", 
			},
			automatic_installation = true,
			handlers = {
				function(server_name)
					require('lspconfig')[server_name].setup({})
				end,
				["lua_ls"] = function()
					require('lspconfig').lua_ls.setup({
						settings = {
							Lua = {
								runtime = { version = 'LuaJIT' },
								workspace = {
									checkThirdParty = false,
									library = { vim.env.VIMRUNTIME },
								},
								diagnostics = { globals = { 'vim' } },
								telemetry = { enable = false },
							},
						},
					})
				end,
			},
		})

		-- nvim-cmp setup
		local cmp = require('cmp')
		local luasnip = require('luasnip')

		-- custom snippets HTML
		local s = luasnip.snippet
		local t = luasnip.text_node
		local i = luasnip.insert_node

		luasnip.add_snippets("html", {
			-- Basic tags
			s("div", { t("<div>"), i(1), t("</div>") }),
			s("p", { t("<p>"), i(1), t("</p>") }),
			s("span", { t("<span>"), i(1), t("</span>") }),
			s("section", { t("<section>"), i(1), t("</section>") }),
			s("article", { t("<article>"), i(1), t("</article>") }),

			-- Headings
			s("h1", { t("<h1>"), i(1), t("</h1>") }),
			s("h2", { t("<h2>"), i(1), t("</h2>") }),
			s("h3", { t("<h3>"), i(1), t("</h3>") }),
			s("h4", { t("<h4>"), i(1), t("</h4>") }),

			-- Lists
			s("ul", { t("<ul>"), i(1), t("</ul>") }),
			s("ol", { t("<ol>"), i(1), t("</ol>") }),
			s("li", { t("<li>"), i(1), t("</li>") }),

			-- Links & Media
			s("a", {
				t('<a href="'), i(1, "https://"), t('">'),
				i(2, "Link Text"), t("</a>")
			}),
			s("img", {
				t('<img src="'), i(1, "image.png"), t('" alt="'), i(2, "description"), t('">')
			}),
			s("video", {
				t('<video controls src="'), i(1, "video.mp4"), t('"></video>')
			}),
			s("audio", {
				t('<audio controls src="'), i(1, "audio.mp3"), t('"></audio>')
			}),

			-- Forms
			s("form", {
				t('<form action="'), i(1, "/submit"), t('" method="'), i(2, "post"), t('">'),
				i(3),
				t("</form>")
			}),
			s("input", {
				t('<input type="'), i(1, "text"), t('" name="'), i(2, "name"), t('" placeholder="'), i(3, "placeholder"), t(
			'">')
			}),
			s("button", {
				t('<button type="'), i(1, "button"), t('">'), i(2, "Click Me"), t("</button>")
			}),
			s("label", {
				t('<label for="'), i(1, "id"), t('">'), i(2, "Label Text"), t("</label>")
			}),
			s("textarea", {
				t('<textarea name="'), i(1, "message"), t('" rows="'), i(2, "4"), t('" cols="'), i(3, "50"), t('">'),
				i(4, "Type here..."),
				t("</textarea>")
			}),

			-- Meta & Structure
			s("html5", {
				t({
					"<!DOCTYPE html>",
					"<html lang=\"en\">",
					"<head>",
					"  <meta charset=\"UTF-8\">",
					"  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">",
					"  <title>",
				}),
				i(1, "Document"),
				t({
					"</title>",
					"</head>",
					"<body>",
					i(2),
					"</body>",
					"</html>",
				}),
			}),
		})


		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			sources = {
				{ name = 'nvim_lsp' },
				{ name = 'luasnip' },
				{ name = 'path' },
				{ name = 'buffer' },
			},
			performance = {
				debounce = 200,
				throttle = 200,
				fetching_timeout = 100,
				max_view_entries = 20,
			},
			mapping = {
				['<C-n>'] = cmp.mapping.select_next_item(),
				['<C-p>'] = cmp.mapping.select_prev_item(),
				['<C-b>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete(),
				['<C-e>'] = cmp.mapping.abort(),
				['<CR>'] = cmp.mapping.confirm({ select = true }),
				['<Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					elseif luasnip.expand_or_jumpable() then
						luasnip.expand_or_jump()
					else
						fallback()
					end
				end, { 'i', 's' }),
				['<S-Tab>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { 'i', 's' }),
			},
		})

		-- nvim-autopairs integration
		local cmp_autopairs = require('nvim-autopairs.completion.cmp')
		cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
	end,
}
