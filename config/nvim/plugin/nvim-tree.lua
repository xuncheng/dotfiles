-- vscode-neovim brings its own; nothing here is wanted there
if vim.g.vscode then
  return
end

vim.pack.add({ "https://github.com/nvim-tree/nvim-tree.lua" })

-- A sidebar close to VSCode's: git status at the right edge, no root path line

vim.keymap.set("n", "<C-n>", "<cmd>NvimTreeToggle<cr>", { desc = "Explorer" })

require("nvim-tree").setup({
  filters = {
    dotfiles = true,
    -- A project's .nvim.lua sets nvim_tree_hide, and 'exrc' sources it after
    -- this config has been read, so the list is looked up per match rather
    -- than captured here. work-ignore writes the fragments
    custom = function(path)
      for _, fragment in ipairs(vim.g.nvim_tree_hide or {}) do
        if path:find(fragment, 1, true) then
          return true
        end
      end
      return false
    end,
  },
  -- An expanded directory repeats what its visible children already show;
  -- a collapsed one is the only place the summary carries information
  git = { show_on_open_dirs = false },
  -- Unsaved buffers are marked too, which is the only cue a file is dirty
  -- while the tree has focus. Same reasoning as git above for open dirs.
  modified = { enable = true, show_on_open_dirs = false },
  -- Keeps the cursor on the first letter of the filename rather than letting
  -- it land on the arrow or the icon
  hijack_cursor = true,
  -- Reveal the current buffer in the tree, uncollapsing folders on the way
  -- update_root stays off so opening a file elsewhere never moves the root
  update_focused_file = { enable = true },
  view = { width = 40 },
  renderer = {
    -- The path line above the tree repeats what the statusline already says
    root_folder_label = false,
    -- Cargo.toml / Makefile / README.md are underlined by default, which
    -- reads as a link and singles out files that are not special here
    special_files = {},
    indent_width = 3,
    icons = {
      -- Markers sit at the right edge rather than crowding in before every
      -- name, the way VSCode places it
      git_placement = "right_align",
      hidden_placement = "right_align",
      modified_placement = "right_align",
      -- Dotfiles are filtered out above; H reveals them, and this marks which
      -- of the visible entries are the revealed ones
      show = { hidden = true },
      glyphs = {
        -- The deleted marker sits on a directory that still exists, which
        -- reads as the directory itself being gone
        git = { deleted = "" },
        default = "󰈚",
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
        },
      },
    },
  },
})
