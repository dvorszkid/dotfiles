return {
  "nvim-mini/mini.surround",
  opts = function(_, opts)
    opts.custom_surroundings = {
      ["m"] = { output = { left = "std::move(", right = ")" } },
    }
  end,
}
