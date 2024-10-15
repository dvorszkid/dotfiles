require("config.keymaps.helpers")

map("n", "<F4>", ":ClangdSwitchSourceHeader <CR>", { silent = true, desc = "Navigation Switch to header/source" })
