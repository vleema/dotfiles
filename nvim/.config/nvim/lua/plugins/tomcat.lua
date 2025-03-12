return {
  "javiorfo/nvim-wildcat",
  lazy = false,
  cmd = { "WildcatRun", "WildcatUp", "WildcatInfo" },
  dependencies = { "javiorfo/nvim-popcorn" },
  opts = {
    -- Not necessary. Only if you want to change the setup
    -- The following are the default values

    console_size = 15,
    -- jboss = {
    --   home = "JBOSS_HOME",
    --   app_base = "standalone/deployments",
    --   default = true,
    -- },
    tomcat = {
      home = "/usr/share/tomcat10",
      app_base = "webapps",
      default = true,
    },
  },
}
