return {
  "MeanderingProgrammer/render-markdown.nvim",
  opts = {
    code = {
      -- snacks.image overlays the rendered Mermaid diagram on its code block
      -- (see snacks.lua), one image row per line. The language label and
      -- background drawn here land on the same lines and cut rows out of the
      -- diagram, so leave Mermaid blocks to snacks.
      disable = { "mermaid" },
    },
  },
}
