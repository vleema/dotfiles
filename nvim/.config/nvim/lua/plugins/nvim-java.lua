return {
  "nvim-java/nvim-java",
  config = false,
  dependencies = {
    {
      "neovim/nvim-lspconfig",
      opts = {
        servers = {
          jdtls = {
            root_dir = function(fname)
              return require("lspconfig").util.root_pattern(
                ".git", -- Git repository
                "mvnw", -- Maven wrapper
                "gradlew", -- Gradle wrapper
                "pom.xml", -- Maven
                "build.gradle", -- Gradle
                "build.gradle.kts" -- Kotlin Gradle
              )(fname) or vim.fn.getcwd()
            end,
          },
        },
        setup = {
          jdtls = function()
            require("java").setup({
              -- Your custom nvim-java configuration goes here
            })
          end,
        },
      },
    },
  },
}
