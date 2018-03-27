defmodule ExULID.ULID do
  @moduledoc """
  This module provides data encoding and decoding functions
  according to [ULID](https://github.com/ulid/spec).
  """
  import ExULID.Crockford

  @max_time 281474976710655 # (2 ^ 48) - 1

  @doc """
  Generates a ULID.
  """
  def generate do
    :milli_seconds
    |> :os.system_time()
    |> generate()
  end

  @doc """
  Generates a ULID at the given timestamp (in millseconds).
  """
  def generate(time) when not is_integer(time) do
    {:error, "time must be an integer, got #{inspect(time)}"}
  end
  def generate(time) when time < 0 do
    {:error, "time cannot be negative, got #{inspect(time)}"}
  end
  def generate(time) when time > @max_time do
    {:error, "time cannot be >= 2^48 milliseconds, got #{inspect(time)}"}
  end
  def generate(time) do
    rand = :crypto.strong_rand_bytes(10)
    encode(time, 10) <> encode(rand, 16)
  end

  defp encode(data, str_length) do
    case encode32(data) do
      {:ok, encoded} ->
        format_encoded(encoded, str_length)
      {:error, _} = error ->
        error
    end
  end

  defp format_encoded(encoded, str_length) do
    case String.length(encoded) do
      n when n > str_length ->
        String.slice(encoded, -str_length..-1)
      n when n < str_length ->
        String.pad_leading(encoded, str_length, "0")
      ^str_length ->
        encoded
    end
  end

  @doc """
  Decodes the given ULID into a tuple of `{time, randomess}`,
  where `time` is the embedded unix timestamp in milliseconds.
  """
  def decode(<<time::bytes-size(10), id::bytes-size(16)>>) do
    case decode_time(time) do
      {:error, _} = error ->
        error
      decoded_time ->
        {decoded_time, id}
    end
  end
  def decode(ulid) do
    {:error, "the ULID must be 26 characters long, got #{inspect(ulid)}"}
  end

  defp decode_time(ulid) do
    decoded =
      ulid
      |> String.slice(0..9)
      |> decode32()

    case decoded do
      {:ok, decoded} ->
        binary_to_time(decoded)
      {:error, _} = error ->
        error
    end
  end

  # Rejects decoded time that is greater than or equal to 2 ^ 48
  # because it would not have been encodable in the first place.
  defp binary_to_time(binary) do
    binary
    |> :binary.decode_unsigned()
    |> validate_time()
  end

  defp validate_time(decoded) when is_integer(decoded) and decoded > @max_time do
    {:error, "the decoded time cannot be greater than 2^48, got #{inspect(decoded)}"}
  end
  defp validate_time(decoded) when is_integer(decoded), do: decoded
end
