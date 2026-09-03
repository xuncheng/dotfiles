-- Layered on top of nvim-lspconfig's jsonls
--
-- Only the files actually edited here get a schema; SchemaStore.nvim ships the
-- whole catalogue as a plugin, which is a lot of data for three entries.
-- The server fetches each url on first use, so validation needs the network once.
-- A file carrying its own "$schema" key is honoured regardless of this list.
return {
  settings = {
    json = {
      validate = { enable = true },
      schemas = {
        {
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json",
        },
        {
          fileMatch = { "tsconfig.json", "tsconfig.*.json", "jsconfig.json" },
          url = "https://json.schemastore.org/tsconfig.json",
        },
        {
          fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
          url = "https://json.schemastore.org/prettierrc.json",
        },
        -- Published by Tencent, not in the SchemaStore catalogue
        -- https://docs.cloudbase.net/cli-v1/config
        {
          fileMatch = { "cloudbaserc.json" },
          url = "https://static.cloudbase.net/cli/cloudbaserc.schema.json",
        },
      },
    },
  },
}
