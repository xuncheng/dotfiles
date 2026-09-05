-- vscode-neovim brings its own; nothing here is wanted there
if vim.g.vscode then
  return
end

-- The preview runs on a node app that has to be built after install and after
-- update, so this has to be registered before the add below
vim.api.nvim_create_autocmd("PackChanged", {
  group = vim.api.nvim_create_augroup("custom_mkdp_build", { clear = true }),
  callback = function(ev)
    if ev.data.spec.name ~= "markdown-preview.nvim" then
      return
    end
    if ev.data.kind ~= "install" and ev.data.kind ~= "update" then
      return
    end
    -- The installer is vimscript inside the plugin, so it has to be sourced
    -- first. It is slow even when it decides no build is needed, which is why
    -- it is behind this hook rather than simply run at startup.
    if not ev.data.active then
      vim.cmd.packadd(ev.data.spec.name)
    end
    vim.fn["mkdp#util#install"]()
  end,
})

vim.pack.add({ "https://github.com/iamcco/markdown-preview.nvim" })

-- Browser preview, toggled with <leader>cp

-- Matches github.com; "dark" for the dark one
vim.g.mkdp_theme = "light"

-- The preview only means anything in a markdown buffer, so the mapping
-- exists only there
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("custom_mkdp_keys", { clear = true }),
  pattern = "markdown",
  callback = function(ev)
    vim.keymap.set("n", "<leader>cp", "<cmd>MarkdownPreviewToggle<cr>", {
      buffer = ev.buf,
      desc = "Markdown preview",
    })
  end,
})
