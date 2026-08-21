-- Switch off the more modern UI modules in snacks and add directory filtering
-- to the picker. The parts that do real work — picker, explorer, bigfile,
-- quickfile — stay.

-- Dependency directories and build output, shared by the files, grep and
-- explorer sources
local exclude = {
  "node_modules",
  "miniprogram_npm",
  "unpackage",
  "dist",
  "build",
  "coverage",
  ".git",
  ".next",
  ".nuxt",
  ".output",
  ".cache",
}

return {
  "folke/snacks.nvim",
  opts = {
    dashboard = { enabled = false }, -- start screen
    indent = { enabled = false }, -- indent guides and scope highlighting
    scroll = { enabled = false }, -- smooth scrolling
    notifier = { enabled = false }, -- corner toasts (messages fall back to :messages)
    words = { enabled = false }, -- highlight references under the cursor (also drops ]] [[ <A-n> <A-p>)

    -- becomes fd's -E or rg's -g !
    picker = {
      sources = {
        files = { exclude = exclude },
        grep = { exclude = exclude },
        explorer = { exclude = exclude },
      },
    },
  },
}
