-- Set own mappings
vim.keymap.set("n", "s", require("substitute").operator, { noremap = true, desc = "Substitute (motion)" })
vim.keymap.set("n", "ss", require("substitute").line, { noremap = true, desc = "Substitute (line)" })
-- used by Flash
-- vim.keymap.set("n", "S", require("substitute").eol, { noremap = true, desc = "Substitute (EOL)" })
vim.keymap.set("x", "s", require("substitute").visual, { noremap = true, desc = "Substitute (visual)" })
