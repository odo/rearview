# Rearview

This is an Elixir library inspired by this excellent [writeup](https://github.com/zaboople/klonk/blob/master/TheGURQ.md) ([HN discusion](https://news.ycombinator.com/item?id=33560275)).

It implements an Emacs-style undo-stack which does not throw away state when you undo steps and then do more edits. Instead, the whole history of edits is preserved as a linear timeline. This provides the end-user with a way to travel back and forth in time without the fear of using work.

## Memory cosumption
Rearview stores the states you record (not diffs) so it can consume quite a bit of memory. If each state is large it might be worth switching on compression.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `rearview` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:rearview, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/gurc>.

