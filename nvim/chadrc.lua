---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "ayu_dark",
  statusline = {
    theme = "default",         -- default/vscode/vscode_colored/minimal
    separator_style = "arrow", -- default/round/block/arrow
  },
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require "custom.mappings"

return M
