-- Without a library the server has never heard of `vim` and marks every use of
-- it an undefined global. VIMRUNTIME alone rather than the whole runtimepath:
-- the full list is slow and, when the file being edited is itself part of the
-- config, the server ends up analysing the same directory twice
return {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
        path = { "lua/?.lua", "lua/?/init.lua" },
      },
      workspace = {
        checkThirdParty = false,
        library = { vim.env.VIMRUNTIME },
      },
    },
  },
}
