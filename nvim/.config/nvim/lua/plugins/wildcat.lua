return {
  {
    "javiorfo/nvim-wildcat",
    lazy = true,
    cmd = { "WildcatRun", "WildcatDown", "WildcatUp" },
    dependencies = { "javiorfo/nvim-popcorn" },
    opts = {
      home = "CATALINA_HOME",
      app_base = "webapps",
      default = true,
    },
  },
}
