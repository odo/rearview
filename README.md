# Rearview

This is an Elixir library inspired by this excellent [writeup](https://github.com/zaboople/klonk/blob/master/TheGURQ.md) ([HN discusion](https://news.ycombinator.com/item?id=33560275)).

It implements an Emacs-style undo-stack which does not throw away state when you undo steps and then do more edits. Instead, the whole history of edits is preserved as a linear timeline. This provides the end-user with a way to travel back and forth in time without the fear of losing work.

## Usage
Rearview is just a library, so you have to keep the Rearview state on your side.
In this example, we are storing integers to keep track of the order of inserts.

```elixir
{:ok, state} = Rearview.init()
{:ok, state} = Rearview.record(1, state)
{:ok, state} = Rearview.record(2, state)
{:ok, 1, state} = Rearview.undo(state)
{:ok, 2, state} = Rearview.redo(state)
{:error, :nothing_to_redo} == Rearview.redo(state)
{:ok, state} = Rearview.record(3, state)
{:ok, state} = Rearview.record(4, state)
{:ok, 3, state} = Rearview.undo(state)
{:ok, 2, state} = Rearview.undo(state)
{:ok, 1, state} = Rearview.undo(state)
{:ok, state} = Rearview.record(1.50, state)
{:ok, state} = Rearview.record(1.75, state)
{:ok, 1.50, state} = Rearview.undo(state)
{:ok, 1.75, state} = Rearview.redo(state)
{:ok, 1.50, state} = Rearview.undo(state)
{:ok, 1, state} = Rearview.undo(state)
{:ok, 2, state} = Rearview.undo(state)
{:ok, 3, state} = Rearview.undo(state)
{:ok, 4, state} = Rearview.undo(state)
{:ok, 3, state} = Rearview.undo(state)
{:ok, 2, state} = Rearview.undo(state)
{:ok, 1, state} = Rearview.undo(state)
{:error, :nothing_to_undo} = Rearview.undo(state)
```

## Memory cosumption
Rearview stores the states you record (not diffs) so it can consume quite a bit of memory (even though it's de-duplicated). If each state is large it might be worth switching on compression.

## Installation

The package can be installed by adding `rearview` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:rearview, "~> 0.1.2"}
  ]
end
```

It's available on [Hex](https://hex.pm/packages/rearview).

