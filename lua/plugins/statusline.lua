local function lsp_clients()
  return require("lsp-progress").progress {
    max_size = 60,
    format = function(messages)
      local active_clients = vim.lsp.get_active_clients()
      if #messages > 0 then return "" .. table.concat(messages, ", ") end
      local client_names = {}
      for i, client in ipairs(active_clients) do
        if client and client.name ~= "" then table.insert(client_names, "" .. client.name .. "") end
      end
      return "" .. table.concat(client_names, ", ")
    end,
  }
end

return {
  {
    "linrongbin16/lsp-progress.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("lsp-progress").setup() end,
  },
  {
    event = "VeryLazy",
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "linrongbin16/lsp-progress.nvim",
    },
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
        component_separators = "|",
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { { "mode", separator = { left = "" }, right_padding = 2 } },
        lualine_b = {
          "branch",
          { "diff", symbols = { added = " ", modified = "柳 ", removed = " " } },
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = " ", warn = " ", info = " " },
          },
        },
        lualine_c = { "" },
        lualine_x = { lsp_clients, "filetype" },
        lualine_y = { "" },
        lualine_z = { { "location", separator = { right = "" }, left_padding = 2 } },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_v = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
      },
    },
    config = function(_, opts)
      require("lualine").setup(opts)
      -- listen lsp-progress event and refresh lualine
      vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
      vim.api.nvim_create_autocmd("User", {
        pattern = "LspProgressStatusUpdated",
        group = "lualine_augroup",
        callback = require("lualine").refresh,
      })
    end,
  },
}
