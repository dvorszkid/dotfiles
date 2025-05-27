return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "enter",
      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_next()
          end
        end,
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.snippet_backward()
          else
            return cmp.select_prev()
          end
        end,
        "snippet_backward",
        "fallback",
      },
    },
    completion = {
      ghost_text = {
        -- Disable showing "ghost" (inlay like) text of the possible autocompletions
        enabled = false,
      },
      documentation = {
        auto_show = true,
      },
    },
  },
}
