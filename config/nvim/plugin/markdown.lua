-- vscode-neovim brings its own; nothing here is wanted there
if vim.g.vscode then
  return
end

-- The preview runs on a node app that has to be built after install and after
-- update. Registering the hook here rather than in init.lua keeps this file
-- self-contained, at one cost: on a machine that installs from the lockfile,
-- every plugin is installed during the first vim.pack call in init.lua, which
-- is before this runs. The build is skipped there and has to be done once by
-- hand with `:call mkdp#util#install()`. Updates are unaffected.
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
    vim.cmd.packadd(ev.data.spec.name)
    vim.fn["mkdp#util#install"]()
  end,
})

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
