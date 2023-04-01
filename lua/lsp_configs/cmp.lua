local ok_cmp, cmp = pcall(require, "cmp")
if not ok_cmp then
  print('"nvim-cmp" not available')
  return
end

local ok_luasnip, luasnip = pcall(require, "luasnip")
if not ok_luasnip then
  print('"L3MON4D3/LuaSnip" not available, for use in "nvim-cmp"')
  return
end

local ok_lspkind, lspkind = pcall(require, "lspkind")
if not ok_lspkind then
  print('"onsails/lspkind" not available, for use in "nvim-cmp"')
  return
end

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ["<C-n>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
    ["<C-p>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" }),
    ["<C-d>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<C-u>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-y>"] = cmp.mapping(
    cmp.mapping.confirm({ select = true }),
    { "i", "c" }
    ),
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
},
sources = cmp.config.sources({
  { name = "nvim_lsp" },
  { name = "nvim_lua" },
  { name = "vim_lsp" },
  { name = "luasnip" },
}, {
  { name = "path" },
  { name = "buffer", keyword_length = 4 },
  { name = "treesitter" },
}),
formatting = {
  fields = { "abbr", "kind", "menu" },
  format = lspkind.cmp_format({
    mode = "symbol", -- show only symbol annotations
    with_text = true,
    menu = {
      nvim_lsp = "[LSP]",
      nvim_lua = "[NVLUA]",
      luasnip = "[SNIP]",
      path = "[Path]",
      buffer = "[BUF]",
    },
    maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
  }),
},
view = {
  entries = {
    name = "custom",
    selection_order = "near_cursor",
  },
},
experimental = {
  ghost_text = true,
},
})

-- `/` cmdline setup.
cmp.setup.cmdline("/", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = "buffer" },
  },
})

-- `:` cmdline setup.
cmp.setup.cmdline(":", {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
})
