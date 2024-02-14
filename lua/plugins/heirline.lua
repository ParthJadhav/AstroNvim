return {
  "rebelot/heirline.nvim",
  event = "BufEnter",
  opts = function()
    local status = require "astronvim.utils.status"
    return {
      opts = {
        disable_winbar_cb = function(args)
          return not require("astronvim.utils.buffer").is_valid(args.buf)
            or status.condition.buffer_matches({
              buftype = { "terminal", "prompt", "nofile", "help", "quickfix" },
              filetype = { "NvimTree", "neo%-tree", "dashboard", "Outline", "aerial" },
            }, args.buf)
        end,
      },
      statusline = { -- statusline
        hl = { fg = "fg", bg = "bg" },
        status.component.mode(),
        status.component.git_branch(),
        status.component.file_info { filetype = {}, filename = false, file_modified = false },
        status.component.git_diff(),
        status.component.diagnostics(),
        status.component.fill(),
        status.component.cmd_info(),
        status.component.fill(),
        status.component.lsp(),
        status.component.treesitter(),
        status.component.mode { surround = { separator = "right" } },
      },
      
      statuscolumn = vim.fn.has "nvim-0.9" == 1 and {
        init = function(self) self.bufnr = vim.api.nvim_get_current_buf() end,
        status.component.foldcolumn(),
        status.component.fill(),
        status.component.numbercolumn(),
        status.component.signcolumn(),
      } or nil,
    }
  end,
  config = require "plugins.configs.heirline",
}
