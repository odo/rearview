defmodule GurcTest do
  use ExUnit.Case
  doctest Gurc

  test "init" do
    assert {:ok, _state} = Gurc.init()
  end

  test "impossible undo/redo" do
    {:ok, state} = Gurc.init()
    assert {:error, :nothing_to_undo} == Gurc.undo(state)
    assert {:error, :nothing_to_redo} == Gurc.redo(state)
    {:ok, state} = Gurc.record(1, state)
    assert {:error, :nothing_to_undo} == Gurc.undo(state)
  end

  test "undo" do
    {:ok, state} = Gurc.init()
    {:ok, state} = Gurc.record(1, state)
    {:ok, state} = Gurc.record(2, state)
    assert {:ok, 1, _state} = Gurc.undo(state)
  end

  test "undo compressed" do
    {:ok, state} = Gurc.init(compression: true)
    {:ok, state} = Gurc.record(1, state)
    {:ok, state} = Gurc.record(2, state)
    assert {:ok, 1, _state} = Gurc.undo(state)
  end

  test "undo and redo" do
    {:ok, state} = Gurc.init()
    {:ok, state} = Gurc.record(1, state)
    {:ok, state} = Gurc.record(2, state)
    assert {:ok, 1, state} = Gurc.undo(state)
    assert {:ok, 2, state} = Gurc.redo(state)
    assert {:error, :nothing_to_redo} == Gurc.redo(state)
    {:ok, state} = Gurc.record(3, state)
    {:ok, state} = Gurc.record(4, state)
    assert {:ok, 3, state} = Gurc.undo(state)
    assert {:ok, 2, state} = Gurc.undo(state)
    assert {:ok, 1, state} = Gurc.undo(state)
    assert {:ok, state} = Gurc.record(1.50, state)
    assert {:ok, state} = Gurc.record(1.75, state)
    assert {:ok, 1.50, state} = Gurc.undo(state)
    assert {:ok, 1.75, state} = Gurc.redo(state)
    assert {:ok, 1.50, state} = Gurc.undo(state)
    assert {:ok, 1, state} = Gurc.undo(state)
    assert {:ok, 2, state} = Gurc.undo(state)
    assert {:ok, 3, state} = Gurc.undo(state)
    assert {:ok, 4, state} = Gurc.undo(state)
    assert {:ok, 3, state} = Gurc.undo(state)
    assert {:ok, 2, state} = Gurc.undo(state)
    assert {:ok, 1, state} = Gurc.undo(state)

    assert {:error, :nothing_to_undo} = Gurc.undo(state)
  end

  test "undo and redo compressed" do
    {:ok, state} = Gurc.init(compression: true)
    {:ok, state} = Gurc.record(1, state)
    {:ok, state} = Gurc.record(2, state)
    assert {:ok, 1, state} = Gurc.undo(state)
    assert {:ok, 2, state} = Gurc.redo(state)
    assert {:error, :nothing_to_redo} == Gurc.redo(state)
    {:ok, state} = Gurc.record(3, state)
    {:ok, state} = Gurc.record(4, state)
    assert {:ok, 3, state} = Gurc.undo(state)
    assert {:ok, 2, state} = Gurc.undo(state)
    assert {:ok, 1, state} = Gurc.undo(state)
    assert {:ok, state} = Gurc.record(1.50, state)
    assert {:ok, state} = Gurc.record(1.75, state)
    assert {:ok, 1.50, state} = Gurc.undo(state)
    assert {:ok, 1.75, state} = Gurc.redo(state)
    assert {:ok, 1.50, state} = Gurc.undo(state)
    assert {:ok, 1, state} = Gurc.undo(state)
    assert {:ok, 2, state} = Gurc.undo(state)
    assert {:ok, 3, state} = Gurc.undo(state)
    assert {:ok, 4, state} = Gurc.undo(state)
    assert {:ok, 3, state} = Gurc.undo(state)
    assert {:ok, 2, state} = Gurc.undo(state)
    assert {:ok, 1, state} = Gurc.undo(state)

    assert {:error, :nothing_to_undo} = Gurc.undo(state)
  end
end
