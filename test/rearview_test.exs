defmodule RearviewTest do
  use ExUnit.Case
  doctest Rearview

  test "init" do
    assert {:ok, _state} = Rearview.init()
  end

  test "impossible undo/redo" do
    {:ok, state} = Rearview.init()
    assert {:error, :nothing_to_undo} == Rearview.undo(state)
    assert {:error, :nothing_to_redo} == Rearview.redo(state)
    {:ok, state} = Rearview.record(1, state)
    assert {:error, :nothing_to_undo} == Rearview.undo(state)
  end

  test "undo" do
    {:ok, state} = Rearview.init()
    {:ok, state} = Rearview.record(1, state)
    {:ok, state} = Rearview.record(2, state)
    assert {:ok, 1, _state} = Rearview.undo(state)
  end

  test "undo compressed" do
    {:ok, state} = Rearview.init(compression: true)
    {:ok, state} = Rearview.record(1, state)
    {:ok, state} = Rearview.record(2, state)
    assert {:ok, 1, _state} = Rearview.undo(state)
  end

  test "undo and redo" do
    {:ok, state} = Rearview.init()
    {:ok, state} = Rearview.record(1, state)
    {:ok, state} = Rearview.record(2, state)
    assert {:ok, 1, state} = Rearview.undo(state)
    assert {:ok, 2, state} = Rearview.redo(state)
    assert {:error, :nothing_to_redo} == Rearview.redo(state)
    {:ok, state} = Rearview.record(3, state)
    {:ok, state} = Rearview.record(4, state)
    assert {:ok, 3, state} = Rearview.undo(state)
    assert {:ok, 2, state} = Rearview.undo(state)
    assert {:ok, 1, state} = Rearview.undo(state)
    assert {:ok, state} = Rearview.record(1.50, state)
    assert {:ok, state} = Rearview.record(1.75, state)
    assert {:ok, 1.50, state} = Rearview.undo(state)
    assert {:ok, 1.75, state} = Rearview.redo(state)
    assert {:ok, 1.50, state} = Rearview.undo(state)
    assert {:ok, 1, state} = Rearview.undo(state)
    assert {:ok, 2, state} = Rearview.undo(state)
    assert {:ok, 3, state} = Rearview.undo(state)
    assert {:ok, 4, state} = Rearview.undo(state)
    assert {:ok, 3, state} = Rearview.undo(state)
    assert {:ok, 2, state} = Rearview.undo(state)
    assert {:ok, 1, state} = Rearview.undo(state)

    assert {:error, :nothing_to_undo} = Rearview.undo(state)
  end

  test "undo and redo compressed" do
    {:ok, state} = Rearview.init(compression: true)
    {:ok, state} = Rearview.record(1, state)
    {:ok, state} = Rearview.record(2, state)
    assert {:ok, 1, state} = Rearview.undo(state)
    assert {:ok, 2, state} = Rearview.redo(state)
    assert {:error, :nothing_to_redo} == Rearview.redo(state)
    {:ok, state} = Rearview.record(3, state)
    {:ok, state} = Rearview.record(4, state)
    assert {:ok, 3, state} = Rearview.undo(state)
    assert {:ok, 2, state} = Rearview.undo(state)
    assert {:ok, 1, state} = Rearview.undo(state)
    assert {:ok, state} = Rearview.record(1.50, state)
    assert {:ok, state} = Rearview.record(1.75, state)
    assert {:ok, 1.50, state} = Rearview.undo(state)
    assert {:ok, 1.75, state} = Rearview.redo(state)
    assert {:ok, 1.50, state} = Rearview.undo(state)
    assert {:ok, 1, state} = Rearview.undo(state)
    assert {:ok, 2, state} = Rearview.undo(state)
    assert {:ok, 3, state} = Rearview.undo(state)
    assert {:ok, 4, state} = Rearview.undo(state)
    assert {:ok, 3, state} = Rearview.undo(state)
    assert {:ok, 2, state} = Rearview.undo(state)
    assert {:ok, 1, state} = Rearview.undo(state)

    assert {:error, :nothing_to_undo} = Rearview.undo(state)
  end
end
