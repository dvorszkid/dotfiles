return {
  "saghen/blink.cmp",
  opts = function(_, opts)
    opts.keymap.preset = "enter"

    opts.keymap["<Tab>"] = {
      function(cmp)
        if cmp.snippet_active() then
          return cmp.accept()
        else
          return cmp.select_next()
        end
      end,
      "snippet_forward",
      "fallback",
    }
    opts.keymap["<S-Tab>"] = {
      function(cmp)
        if cmp.snippet_active() then
          return cmp.snippet_backward()
        else
          return cmp.select_prev()
        end
      end,
      "snippet_backward",
      "fallback",
    }

    -- Disable showing "ghost" (inlay like) text of the possible autocompletions
    opts.completion.ghost_text.enabled = false
  end,
}
