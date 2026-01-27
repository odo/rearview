defmodule Gurc do
  defstruct current: nil, undo: [], redo: [] 

  def init() do
    {:ok, %Gurc{}}
  end

  def record(record, %Gurc{current: current, undo: undo, redo: []} = state) do
    next_undo = [current | undo]
    {:ok, %Gurc{state | current: record, undo: next_undo, redo: []}}
  end
  def record(record, %Gurc{current: current, undo: undo, redo: redo} = state) do
    [_ | redo_reverse] = Enum.reverse(redo)
    next_undo = [current | redo] ++ redo_reverse ++ [current] ++ undo
    {:ok, %Gurc{state | current: record, undo: next_undo, redo: []}}
  end

  def undo(%Gurc{undo: []}) do
    {:error, :nothing_to_undo}
  end
  def undo(%Gurc{undo: [_]}) do
    {:error, :nothing_to_undo}
  end
  def undo(%Gurc{current: current, undo: [last | rest_undo], redo: redo} = state) do
    {:ok, last, %Gurc{state | current: last, undo: rest_undo, redo: [current | redo]}}
  end

  def redo(%Gurc{redo: []}) do
    {:error, :nothing_to_redo}
  end
  def redo(%Gurc{current: current, redo: [first | rest_redo], undo: undo} = state) do
    {:ok, first, %Gurc{state | current: first, undo: [current | undo], redo: rest_redo}}
  end
end
