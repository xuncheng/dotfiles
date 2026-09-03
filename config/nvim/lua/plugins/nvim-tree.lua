-- A sidebar close to VSCode's: git status at the right edge, no root path
-- line, no indent guides
return {
  "nvim-tree/nvim-tree.lua",
  cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  keys = {
    { "<C-n>", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
    { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
  },
  opts = {
    filters = { dotfiles = true },
    -- An expanded directory repeats what its visible children already show;
    -- a collapsed one is the only place the summary carries information
    git = { show_on_open_dirs = false },
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
      -- Git status the way VSCode places it: the name carries the colour and
      -- the marker sits at the right edge, rather than crowding in before
      -- every name. The markers themselves are nvim-tree's own defaults.
      highlight_git = "name",
      icons = {
        git_placement = "right_align",
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
  },
}
