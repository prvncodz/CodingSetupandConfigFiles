return {
  "hrsh7th/nvim-cmp",
  optional = true,
  opts = function(_, opts)
    local cmp = require("cmp")
    local kinds = vim.lsp.protocol.CodeActionKind

    opts.mapping["<CR>"] = cmp.mapping(function(fallback)
      -- If completion menu is open → confirm selection
      if cmp.visible() then
        cmp.confirm({ select = true })

        -- Run auto-import AFTER text is inserted
        vim.defer_fn(function()
          vim.lsp.buf.code_action({
            apply = true,
            context = {
              diagnostics = {},
              only = {
                kinds.SourceAddMissingImports,
                kinds.SourceOrganizeImports,
              },
            },
          })
        end, 30)
      else
        -- If completion menu NOT open → normal Enter
        fallback()
      end
    end, { "i", "s" })

    return opts
  end,
}
