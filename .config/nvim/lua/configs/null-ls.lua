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
    b.formatting.prettier.with({ filetypes = { "html", "markdown", "css", "javascript", "typescript" } }),
}

-- TODO: try conform plugin instead of this
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
null_ls.setup({
    debug = true,
    sources = sources,
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                    -- on later neovim version, you should use vim.lsp.buf.format({ async = false }) instead
                    vim.lsp.buf.format({ async = false })
                end,
            })
        end
    end,
})
