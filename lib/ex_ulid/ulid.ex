defmodule ExULID.ULID do
  @moduledoc """
  This module provides data encoding and decoding functions
  according to [ULID](https://github.com/ulid/spec).
  """
  import ExULID.Crockford

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
    encode_formatted(time, 10) <> encode_formatted(rand, 16)
  end

  @doc """
  Encode the data and format it to a specific string length.
  """
  def encode_formatted(data, str_length) do
    data
    |> encode32()
    |> format_encoded(str_length)
  end

  def format_encoded(encoded, str_length) do
    case String.length(encoded) do
      n when n > str_length ->
        String.slice(encoded, -str_length..-1)
      n when n < str_length ->
        String.pad_leading(encoded, str_length, "0")
      ^str_length ->
        encoded
    end
  end

  # @doc """
  # Decodes the given ULID into a tuple of `{time, random_id}`,
  # where `time` is the embedded unix timestamp in milliseconds.
  # """
  # def decode(ulid) do
  #   {decode_time(ulid), String.slice(ulid, 10..25)}
  # end

  # @doc """
  # Decodes the given ULID and returns only the embedded unix timestamp in milliseconds.
  # """
  # def decode_time(ulid) do
  #   ulid
  #   |> String.slice(0..9)
  #   |> String.pad_trailing(16, "=")
  #   |> decode32()
  #   |> elem(1)
  #   |> :binary.decode_unsigned()
  # end

  defp to_integer(<<a::8>>) do
    a
  end
  defp to_integer(<<_::8, _::8>> = data) do
    <<int::integer-unsigned-16>> = data
    int
  end
  defp to_integer(<<_::8, _::8, _::8>> = data) do
    <<int::integer-unsigned-24>> = data
    int
  end
  defp to_integer(<<_::8, _::8, _::8, _::8>> = data) do
    <<int::integer-unsigned-32>> = data
    int
  end
  defp to_integer(<<_::8, _::8, _::8, _::8, _::8>> = data) do
    <<int::integer-unsigned-40>> = data
    int
  end
  defp to_integer(<<_::8, _::8, _::8, _::8, _::8, _::8>> = data) do
    <<int::integer-unsigned-48>> = data
    int
  end
  defp to_integer(<<_::8, _::8, _::8, _::8, _::8, _::8, _::8>> = data) do
    <<int::integer-unsigned-56>> = data
    int
  end
end
