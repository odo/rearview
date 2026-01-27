# Gurc 🥒 (Great Undo-Redo Closure)

This is a Elixir library inspired by this excellent [writeup](https://github.com/zaboople/klonk/blob/master/TheGURQ.md).

It implements an undo-stack which does not throw away state when you undo steps and then do more edits. Instead, the whole history of editing is preserved as a linear timeline. This provides the end-user with a way to travel back and forth in time without the fear of using work.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `gurc` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:gurc, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/gurc>.

