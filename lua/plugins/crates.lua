return {
  "saecki/crates.nvim",
  ft = { "toml" },
  config = function(_, opts)
    local crates = require "crates"
    crates.setup(opts)
    require("cmp").setup.buffer {
      sources = { { name = "crates" } },
    }
    crates.show()
  end,
}
