-- :checkhealth deps
--
-- lsp.lua, conform.lua and fzf-lua.lua all reach for binaries on $PATH that
-- nothing here installs, and a missing one is silent: the server never
-- attaches, conform skips the formatter, the picker comes up empty. This is
-- the install commands from those files' comments, made runnable.

-- required marks the ones nothing falls back to, so a miss is an error rather
-- than a feature that quietly does not exist
local function check(specs)
  for _, spec in ipairs(specs) do
    if vim.fn.executable(spec.bin) == 1 then
      vim.health.ok(spec.bin .. " — " .. spec.what)
    else
      local report = spec.required and vim.health.error or vim.health.warn
      report(spec.bin .. " not found — " .. spec.what, spec.install)
    end
  end
end

-- In the order lsp.lua enables them.
-- jsonls and eslint are two binaries out of one package
local servers = {
  {
    bin = "ruby-lsp",
    what = "ruby_lsp",
    install = { "gem install ruby-lsp", "or let the project's Gemfile carry it" },
  },
  { bin = "vtsls", what = "vtsls", install = "volta install @vtsls/language-server" },
  { bin = "vscode-json-language-server", what = "jsonls", install = "brew install vscode-langservers-extracted" },
  { bin = "marksman", what = "marksman", install = "brew install marksman" },
  { bin = "vscode-eslint-language-server", what = "eslint", install = "brew install vscode-langservers-extracted" },
  { bin = "lua-language-server", what = "lua_ls", install = "brew install lua-language-server" },
}

-- conform resolves prettier and rubocop out of the project before $PATH, so a
-- global miss only bites in projects that carry neither
local formatters = {
  { bin = "stylua", what = "conform: lua", install = "brew install stylua" },
  {
    bin = "prettier",
    what = "conform: css, html, javascript, json, markdown, scss, typescript, yaml",
    install = { "brew install prettier", "or ignore this: node_modules/.bin/prettier wins where a project has one" },
  },
  {
    bin = "rubocop",
    what = "conform: ruby",
    install = { "gem install rubocop", "or ignore this: the project's bundle wins where it has one" },
  },
}

-- vim.pack shells out to git for every install and update, and asking it
-- anything without one raises rather than returning empty
local plugins = {
  { bin = "git", what = "vim.pack: install and update", install = "xcode-select --install", required = true },
}

local pickers = {
  { bin = "fzf", what = "fzf-lua: every picker", install = "brew install fzf", required = true },
  {
    bin = "rg",
    what = "fzf-lua: live_grep and grep_cword, and 'grepprg'",
    install = "brew install ripgrep",
    required = true,
  },
  -- fzf-lua falls back to find, but on a plain find the --exclude list in
  -- fzf-lua.lua does not apply and node_modules comes back with everything else
  { bin = "fd", what = "fzf-lua: files and its exclude list", install = "brew install fd" },
}

-- markdown-preview runs on a node app that its own installer downloads.
-- plugin/markdown.lua hooks that onto install and update, but a build that
-- failed, or a copy that predates the hook, leaves the preview failing with
-- nothing to say why
local function check_markdown_preview()
  -- pcall so a missing git, which vim.pack.get raises on, costs this one check
  -- rather than aborting the whole report
  local ok, found = pcall(vim.pack.get, { "markdown-preview.nvim" })
  local plugin = ok and found[1]
  if not plugin then
    return
  end
  if #vim.fn.glob(vim.fs.joinpath(plugin.path, "app/bin/markdown-preview-*"), false, true) > 0 then
    vim.health.ok("markdown-preview.nvim — the preview app is built")
  else
    vim.health.warn("markdown-preview.nvim — the preview app was never built", "run :call mkdp#util#install()")
  end
end

return {
  check = function()
    vim.health.start("language servers")
    check(servers)

    vim.health.start("formatters")
    check(formatters)

    vim.health.start("pickers")
    check(pickers)

    vim.health.start("plugins")
    check(plugins)
    check_markdown_preview()
  end,
}
