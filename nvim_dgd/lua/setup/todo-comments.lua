-- FIX: foobar
-- PERF: foobar - this should be purple
-- HACK: foobar
-- DGD: foobar
-- WIP: foobar
-- TODO: foobar
-- NOTE: foobar
-- DOC: foobar - easy on the eyes!
-- TEST: foobar

require("todo-comments").setup(
  {
    keywords = {
      DGD = { color = "def_bright_red" },
      WIP = { color = "def_green" },
      DOC = { color = "def_grey" },
      PERF = { color = "def_purple" },
      TODO = { color = "def_orange" },
      DEPRECATED = { color = "def_orange" }

    },
    colors = {
      def_white = { "", "#EBDBB2" },
      def_grey = { "", "#A89984" },
      def_purple = { "", "#D3869B" },
      def_orange = { "", "#fe8019" },
      def_blue = { "", "#83A598" },      -- Gruvbox blue
      def_green = { "", "#B8BB26" },     -- Gruvbox green
      def_bright_red = { "", "#FB4934" } -- Gruvbox bright red
    },
    merge_keywords = true,
  }
)
