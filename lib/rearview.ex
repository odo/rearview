defmodule Rearview do
  @moduledoc """
  This module implements a linearized, non-destructive undo-redo-stack.
  """

  defstruct options: [], current: nil, undo: [], redo: [], storage: %{} 
  
  @doc """
  Initializes the `Rearview` datastructure.
  
  Compression is optional (default is `false`) which is recommended for small payloads.
  If switched on, the data is [gzipped](https://en.wikipedia.org/wiki/Gzip).

  Returns the datastructure used to manage the undo-redo functionality. It should be treated as opaque.

  ## Examples

      iex> {:ok, _state} = Rearview.init(compression: true)

  """
  def init(options \\ []) do
    options = Keyword.merge([compression: false], options)
    {:ok, %Rearview{options: options}}
  end

  @doc """
  Records a new user-generated state.

  Returns `{:ok, next_state}` with a new undo-redo datastructure.

  ## Example

      iex> {:ok, state} = Rearview.init()
      iex> {:ok, _next_state} = Rearview.record("Three programmers walk into a bar", state)
      {:ok,
       %Rearview{
         options: [compression: false],
         current: 111754976,
         undo: [nil],
         redo: [],
         storage: %{111754976 => "Three programmers walk into a bar"}
       }}

  """
  def record(record, %Rearview{current: current, undo: undo, redo: [], storage: storage, options: options} = state) do
    next_undo = [current | undo]
    {record_hash, next_storage} = add_to_storage(record, storage, options)
    {:ok, %Rearview{state | current: record_hash, undo: next_undo, redo: [], storage: next_storage}}
  end
  def record(record, %Rearview{current: current, undo: undo, redo: redo, storage: storage, options: options} = state) do
    [_ | redo_reverse] = Enum.reverse(redo)
    next_undo = [current | redo] ++ redo_reverse ++ [current] ++ undo
    {record_hash, next_storage} = add_to_storage(record, storage, options)
    {:ok, %Rearview{state | current: record_hash, undo: next_undo, redo: [], storage: next_storage}}
  end

  @doc """
  Reverts to a previously recoded user state.

  Returns `{:ok, previous_user_state, next_state}` or `{:error, :nothing_to_undo}`.

  ## Example

      iex> {:ok, state} = Rearview.init()
      iex> {:ok, state} = Rearview.record("Three programmers walk", state)
      iex> {:ok, state} = Rearview.record("Three programmers walk into a bar", state)
      iex> {:ok, _old_record, _state} = Rearview.undo(state)
      {:ok, "Three programmers walk",
       %Rearview{
         options: [compression: false],
         current: 93678342,
         undo: [nil],
         redo: [111754976],
         storage: %{
           93678342 => "Three programmers walk",
           111754976 => "Three programmers walk into a bar"
         }
       }}

  """
  def undo(%Rearview{undo: []}) do
    {:error, :nothing_to_undo}
  end
  def undo(%Rearview{undo: [_]}) do
    {:error, :nothing_to_undo}
  end
  def undo(%Rearview{current: current, undo: [last | rest_undo], redo: redo, storage: storage, options: options} = state) do
    {:ok, get_from_storage(last, storage, options), %Rearview{state | current: last, undo: rest_undo, redo: [current | redo]}}
  end

  @doc """
  Forwards to a user state next_state was previously reverted.

  Returns `{:ok, reverted_user_state, next_state}` or `{:error, :nothing_to_redo}`.

  ## Example

      iex> {:ok, state} = Rearview.init()
      iex> {:ok, state} = Rearview.record("Three programmers walk", state)
      iex> {:ok, state} = Rearview.record("Three programmers walk into a bar", state)
      iex> {:ok, _, state} = Rearview.undo(state)
      iex> {:ok, _, _state} = Rearview.redo(state)
      {:ok, "Three programmers walk into a bar",
       %Rearview{
         options: [compression: false],
         current: 111754976,
         undo: [93678342, nil],
         redo: [],
         storage: %{
           93678342 => "Three programmers walk",
           111754976 => "Three programmers walk into a bar"
         }
       }}

  """
  def redo(%Rearview{redo: []}) do
    {:error, :nothing_to_redo}
  end
  def redo(%Rearview{current: current, redo: [first | rest_redo], undo: undo, storage: storage, options: options} = state) do
    {:ok, get_from_storage(first, storage, options), %Rearview{state | current: first, undo: [current | undo], redo: rest_redo}}
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
    Map.get(storage, hash) |> maybe_decompress(compression)
  end

  defp maybe_compress(payload, false), do: payload
  defp maybe_compress(payload, true) do
      payload |> :erlang.term_to_binary() |> :zlib.gzip()
  end

  defp maybe_decompress(payload, false), do: payload
  defp maybe_decompress(payload, true) do
      payload |> :zlib.gunzip() |> :erlang.binary_to_term()
  end
end
