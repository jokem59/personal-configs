-- LSP: like emacs/.emacs.d/lisp/init-eglot.el, start a server for every
-- language whose server is installed. setup.sh (setup_language_servers)
-- installs them; nothing here downloads servers. nvim-lspconfig supplies each
-- server's default cmd/filetypes/root markers; we only override what differs.
-- `:checkhealth vim.lsp' shows what's enabled and attached.

-- nvim-lspconfig name -> executable that must be on PATH
local servers = {
  bashls = "bash-language-server",
  clangd = "clangd",
  cssls = "vscode-css-language-server",
  gopls = "gopls",
  html = "vscode-html-language-server",
  jsonls = "vscode-json-language-server",
  lua_ls = "lua-language-server",
  luau_lsp = "luau-lsp",
  marksman = "marksman",
  rust_analyzer = "rust-analyzer",
  taplo = "taplo",
  ts_ls = "typescript-language-server",
  yamlls = "yaml-language-server",
}

-- Python: first available, in init-eglot.el's order.
for _, py in ipairs({
  { "ty", "ty" },
  { "basedpyright", "basedpyright-langserver" },
  { "pyright", "pyright-langserver" },
  { "pylsp", "pylsp" },
}) do
  if vim.fn.executable(py[2]) == 1 then
    servers[py[1]] = py[2]
    break
  end
end

for name, exe in pairs(servers) do
  if vim.fn.executable(exe) == 1 then
    vim.lsp.enable(name)
  end
end

-- Same flags as helix/languages.toml.
vim.lsp.config("clangd", { cmd = { "clangd", "--header-insertion=never" } })

-- ty: prefer the project's own .venv (what game-engine type-checks with), as
-- init-eglot.el does, falling back to the one on PATH.
vim.lsp.config("ty", {
  cmd = function(dispatchers, config)
    local venv_ty = config.root_dir and vim.fs.joinpath(config.root_dir, ".venv/bin/ty")
    local exe = (venv_ty and vim.fn.executable(venv_ty) == 1) and venv_ty or "ty"
    return vim.lsp.rpc.start({ exe, "server" }, dispatchers, { cwd = config.root_dir })
  end,
})

-- lua_ls: teach it about the `vim' API, but only when editing this config, so
-- other Lua projects keep their own runtime settings.
vim.lsp.config("lua_ls", {
  on_init = function(client)
    local root = client.workspace_folders and client.workspace_folders[1].name
    local config_dir = vim.uv.fs_realpath(vim.fn.stdpath("config"))
    if not (root and config_dir and vim.startswith(config_dir, vim.uv.fs_realpath(root) or root)) then
      return
    end
    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
      runtime = { version = "LuaJIT" },
      workspace = { checkThirdParty = false, library = { vim.env.VIMRUNTIME } },
    })
  end,
})

-- Helix auto-formats these on save (lua via languages.toml, go/rust by default).
local format_on_save = { lua = true, go = true, rust = true }

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if format_on_save[vim.bo[args.buf].filetype] and client:supports_method("textDocument/formatting") then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 2000 })
        end,
      })
    end
  end,
})

-- Helix shows diagnostics in the gutter plus underlines; add the message
-- inline on the cursor's line only, so the rest of the buffer stays quiet.
vim.diagnostic.config({
  virtual_text = { current_line = true },
  severity_sort = true,
  float = { source = "if_many" },
})
