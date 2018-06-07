%{
  configs: [
    %{
      name: "default",
      color: true,
      files: %{
        # The default glob pattern matching doesn't match files starting with a '.'
        included:
          ["config/", "lib/", "test/", "*.exs"] ++ Path.wildcard(".*.exs", match_dot: true),
        excluded: ["test/support"]
      },
      checks: [
        # Don't fail on TODOs and FIXMEs for now
        {Credo.Check.Design.TagTODO, exit_status: 0},
        {Credo.Check.Design.TagFIXME, exit_status: 0},

        # Sometimes Foo.Bar.thing is cleaner than an alias
        {Credo.Check.Design.AliasUsage, if_nested_deeper_than: 2},

        # mix format defaults to a line length of 98
        {Credo.Check.Readability.MaxLineLength, max_length: 98}
      ]
    }
  ]
}
