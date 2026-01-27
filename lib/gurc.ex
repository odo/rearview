defmodule Gurc do
  defstruct options: [], current: nil, undo: [], redo: [], storage: %{} 

  def init(options \\ []) do
    options = Keyword.merge([compression: false], options)
    {:ok, %Gurc{options: options}}
  end

  def record(record, %Gurc{current: current, undo: undo, redo: [], storage: storage, options: options} = state) do
    next_undo = [current | undo]
    {record_hash, next_storage} = add_to_storage(record, storage, options)
    {:ok, %Gurc{state | current: record_hash, undo: next_undo, redo: [], storage: next_storage}}
  end
  def record(record, %Gurc{current: current, undo: undo, redo: redo, storage: storage, options: options} = state) do
    [_ | redo_reverse] = Enum.reverse(redo)
    next_undo = [current | redo] ++ redo_reverse ++ [current] ++ undo
    {record_hash, next_storage} = add_to_storage(record, storage, options)
    {:ok, %Gurc{state | current: record_hash, undo: next_undo, redo: [], storage: next_storage}}
  end

  def undo(%Gurc{undo: []}) do
    {:error, :nothing_to_undo}
  end
  def undo(%Gurc{undo: [_]}) do
    {:error, :nothing_to_undo}
  end
  def undo(%Gurc{current: current, undo: [last | rest_undo], redo: redo, storage: storage, options: options} = state) do
    {:ok, get_from_storage(last, storage, options), %Gurc{state | current: last, undo: rest_undo, redo: [current | redo]}}
  end

  def redo(%Gurc{redo: []}) do
    {:error, :nothing_to_redo}
  end
  def redo(%Gurc{current: current, redo: [first | rest_redo], undo: undo, storage: storage, options: options} = state) do
    {:ok, get_from_storage(first, storage, options), %Gurc{state | current: first, undo: [current | undo], redo: rest_redo}}
  end

  defp add_to_storage(record, storage, [compression: compression]) do
    hash = :erlang.phash2(record)
    case Map.has_key?(storage, hash) do
      true ->
        {hash, storage}
      false ->
        {hash, Map.put(storage, hash, maybe_compress(record, compression))}
    end
  end
  defp get_from_storage(hash, storage, [compression: compression]) do
    Map.get(storage, hash)
      |> maybe_decompress(compression)
  end

  def maybe_compress(payload, false), do: payload
  def maybe_compress(payload, true) do
      payload |> :erlang.term_to_binary() |> :zlib.gzip()
  end
  
  def maybe_decompress(payload, false), do: payload
  def maybe_decompress(payload, true) do
      payload |> :zlib.gunzip() |> :erlang.binary_to_term()
  end
end
