-- FIX: foobar
-- PERF: foobar - this should be purple
-- HACK: foobar
-- DGD: foobar
-- TODO: foobar
-- NOTE: foobar
-- DOC: foobar - easy on the eyes!
-- TEST: foobar

require("todo-comments").setup(
  {
    keywords = {
      DGD = { color = "warning" },
      DOC = { color = "def_grey" },
      PERF = { color = "def_purple" },
      TODO = { color = "def_orange" }

    },
    colors = {
      def_white = { "", "#EBDBB2" },
      def_grey = { "", "#A89984" },
      def_purple = { "", "#D3869B" },
      def_orange = { "", "#fe8019" }
    },
    merge_keywords = true,
  }
)
