local present, p = pcall(require, "nvim-tmux-navigation")

if not present then
    return
end

p.setup({
    disable_when_zoomed = true,
    keybindings = {
        left = "<C-h>",
        down = "<C-j>",
        up = "<C-k>",
        right = "<C-l>",
        -- last_active = "<C-\\>",
    },
})
