-- Keep picker, explorer, bigfile and quickfile; drop the decorative modules

-- Dependency directories and build output, shared by files/grep/explorer
-- Each entry becomes fd's -E or rg's -g !
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
    -- dashboard  start screen
    -- indent     indent guides and scope highlighting
    -- scroll     smooth scrolling
    -- notifier   corner toasts; messages fall back to :messages
    -- words      references under the cursor; also drops ]] [[ <A-n> <A-p>
    dashboard = { enabled = false },
    indent = { enabled = false },
    scroll = { enabled = false },
    notifier = { enabled = false },
    words = { enabled = false },

    picker = {
      sources = {
        -- hidden: dotfiles are ordinary files in a dotfiles-heavy tree
        -- ignored stays off, so .gitignore keeps node_modules and build output out
        files = { exclude = exclude, hidden = true },
        grep = { exclude = exclude, hidden = true },
        explorer = { exclude = exclude, hidden = true },
      },
    },
  },
}
