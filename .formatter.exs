[
  plugins: [TailwindFormatter.MultiFormatter],
  inputs: [
    "*.{heex,ex,exs}",
    "priv/*/seeds.exs",
    "{config,lib,test}/**/*.{heex,ex,exs}"
  ],
  plugins: [Styler],
  line_length: 100_000
]
