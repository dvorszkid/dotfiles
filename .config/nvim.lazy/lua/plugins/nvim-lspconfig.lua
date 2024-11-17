return {
  "nvim-lspconfig",
  opts = {
    inlay_hints = {
      enabled = false,
      --exclude = { "cpp" },
    },
    setup = {
      clangd = function(_, _)
        require("lspconfig").clangd.setup({
          cmd = {
            "clangd",
            "--clang-tidy",
            "--header-insertion=never",
            "--completion-style=detailed",
            "--background-index",
          },
        })
        return true
      end,
      rust_analyzer = function(_, _)
        require("lspconfig").rust_analyzer.setup({
          settings = {
            ["rust_analyzer"] = {
              cargo = {
                allFeatures = true,
              },
            },
          },
        })
        return true
      end,
      lua_ls = function(_, _)
        require("lspconfig").lua_ls.setup({
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim", "hs" },
              },
              workspace = {
                library = {
                  [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                  [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                  ["/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/"] = true,
                },
              },
            },
          },
        })
        return true
      end,
      powershell_es = function(_, _)
        require("lspconfig").powershell_es.setup({
          settings = {
            powershell = {
              codeFormatting = {
                -- Preset = "Custom", -- based on Visual Studio Code default settings
                AddWhitespaceAroundPipe = true,
                AlignPropertyValuePairs = true,
                AutoCorrectAliases = false,
                AvoidSemicolonsAsLineTerminators = false,
                IgnoreOneLineBlock = true,
                NewLineAfterCloseBrace = true,
                NewLineAfterOpenBrace = true,
                OpenBraceOnSameLine = true,
                PipelineIndentationStyle = "NoIndentation",
                TrimWhitespaceAroundPipe = false,
                UseConstantStrings = false,
                UseCorrectCasing = false,
                WhitespaceAfterSeparator = true,
                WhitespaceAroundOperator = true,
                WhitespaceBeforeOpenBrace = true,
                WhitespaceBeforeOpenParen = true,
                WhitespaceBetweenParameters = false,
                WhitespaceInsideBrace = false,
              },
            },
          },
        })
        return true
      end,
    },
  },
}
