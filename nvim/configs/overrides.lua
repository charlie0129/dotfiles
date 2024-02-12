local M = {}

M.treesitter = {
  ensure_installed = {
    "bash",
    "c",
    "cpp",
    "css",
    "dockerfile",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "go",
    "gomod",
    "html",
    "javascript",
    "json",
    "latex",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "python",
    "typescript",
    "yaml",
  },
}

M.mason = {
  ensure_installed = {
    "clangd",
    "gopls",
    "bash-language-server",
    "typescript-language-server",

    "pyright",
    "goimports",
    "quick-lint-js",
    "jq",
    "prettier",
    "shfmt",
  },
}

-- git support in nvimtree
M.nvimtree = {
  git = {
    enable = true,
  },

  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
    },
  },
}

M.cmp = {
  sources = {
    { name = "copilot" },
  },
}

return M
