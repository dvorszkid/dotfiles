local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {
  -- git
  b.code_actions.gitsigns,

  -- lua
  b.formatting.stylua,

  -- python
  b.formatting.black,
  b.diagnostics.mypy,
  b.diagnostics.ruff,

  -- cpp
  b.formatting.clang_format,

  -- web
  b.formatting.prettier.with { filetypes = { "html", "markdown", "css" } }, -- so prettier works only on these filetypes
}

null_ls.setup {
  debug = true,
  sources = sources,
}
