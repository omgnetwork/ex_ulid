defmodule ExULID.ULID do
  @moduledoc """
  This module provides data encoding and decoding functions
  according to [ULID](https://github.com/ulid/spec).
  """
  import ExULID.Crockford

  defmodule InvalidTimeError, do: defexception [:message]
  defmodule InvalidULIDError, do: defexception [:message]

  @max_time 281474976710655 # (2 ^ 48) - 1

  @doc """
  Generates a ULID.
  """
  def generate do
    :milli_seconds
    |> :os.system_time()
    |> generate_at()
  end

  @doc """
  Generates a ULID at the given timestamp (in millseconds).
  """
  def generate_at(time) do
    rand = :crypto.strong_rand_bytes(10) # 10 bytes = 80 bits
    encode_time(time) <> encode(rand, 16)
  rescue
    e in InvalidTimeError -> {:error, e.message}
  end

  defp encode_time(time) when not is_integer(time) do
    raise InvalidTimeError, message: "time must be an integer, got #{inspect(time)}"
  end
  defp encode_time(time) when time < 0 do
    raise InvalidTimeError, message: "time cannot be negative, got #{inspect(time)}"
  end
  defp encode_time(time) when time > @max_time do
    raise InvalidTimeError, message: "time cannot be >= 2^48 milliseconds, got #{inspect(time)}"
  end
  defp encode_time(time) do
    encode(time, 10)
  end

  defp encode(data, str_length) do
    data
    |> encode32()
    |> format_encoded(str_length)
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
  def decode(ulid) when byte_size(ulid) != 26 do
    {:error, "the ULID must be 26 characters long, got #{inspect(ulid)}"}
  end
  def decode(ulid) do
    {decode_time(ulid), String.slice(ulid, 10..25)}
  rescue
    e in InvalidULIDError -> {:error, e.message}
  end

  defp decode_time(ulid) do
    ulid
    |> String.slice(0..9)
    |> decode32()
    |> binary_to_time()
  end

  # Rejects decoded time that is greater than or equal to 2 ^ 48
  # because it would not have been encodable in the first place.
  defp binary_to_time({:ok, binary}) do
    binary
    |> :binary.decode_unsigned()
    |> validate_time()
  end
  defp binary_to_time({:error, _} = error), do: error

  defp validate_time(decoded) when is_integer(decoded) and decoded > @max_time do
    raise InvalidULIDError,
          message: "the decoded time cannot be greater than 2^48, got #{inspect(decoded)}"
  end
  defp validate_time(decoded) when is_integer(decoded), do: decoded
end
