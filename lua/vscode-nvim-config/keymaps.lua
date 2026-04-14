vim.keymap.set({ "n", "i", "v" }, "<C-s>", function()
  require("vscode-neovim").call("workbench.action.files.save")
  vim.cmd("stopinsert")
end)

local function save_and_close()
  local vscode = require("vscode")
  vscode.call("workbench.action.files.save")
  vscode.call("workbench.action.closeActiveEditor")
end
vim.keymap.set("n", "<C-x>", save_and_close, { desc = "Save and Close Tab" })
