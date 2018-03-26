defmodule ExULID.Crockford do
  @moduledoc """
  This module provides data encoding and decoding functions
  according to [Crockford's Base32](http://www.crockford.com/wrmg/base32.html).
  """
  @bits 5
  @encoding '0123456789ABCDEFGHJKMNPQRSTVWXYZ'

  defmodule UnknownCharacterError do
    defexception [:message]

    def exception(char) do
      msg = "a character could not be decoded, got: #{inspect char}"
      %UnknownCharacterError{message: msg}
    end
  end

  defp encoding, do: @encoding

  defp decoding do
    @encoding
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn({char, index}, acc) ->
         Map.put(acc, char, index)
       end)
  end

  @spec encode32(binary | integer) :: binary
  def encode32(data) when is_integer(data) do
    data
    |> :binary.encode_unsigned()
    |> encode32()
  end
  # Pad or remove any leading zero
  def encode32(""), do: ""
  def encode32(data) do
    data = pad_bitlength(data, @bits)
    encode32("", data)
  end

  # Ignore leading zeros unless it's the only character
  defp encode32("", <<0::@bits>>), do: "0"
  defp encode32("", <<0::@bits, remainder::bits>>), do: encode32("", remainder)
  # Main meaty part. Take the expected bits, convert to the encoding character,
  # then append the character to the accumulator.
  defp encode32(acc, <<bits::@bits, remainder::bits>>) do
    acc
    |> Kernel.<>(<<Enum.at(encoding(), bits)>>)
    |> encode32(remainder)
  end
  # Last remainder will be an empty binary,
  # the accumulator is now final, return it as the result.
  defp encode32(acc, <<>>), do: acc

  defp pad_bitlength(data, bitlength) when rem(bit_size(data), bitlength) == 0, do: data
  defp pad_bitlength(data, bitlength) when rem(bit_size(data), bitlength) > 0 do
    remainder = rem(bit_size(data), bitlength)
    <<a::size(remainder), remaining::bits>> = data

    if a > 0 do
      missing_bits = bitlength - remainder
      <<(<<0::size(missing_bits)>>), (data::bits)>>
    else
      <<remaining::bits>>
    end
  end

  def decode32("0"), do: {:ok, <<0>>}
  def decode32(string) do
    string = String.to_charlist(string)
    {:ok, decode32("", string)}
  rescue
    e in UnknownCharacterError -> {:error, e.message}
  end

  defp decode32(acc, ''), do: pad_bitlength(acc, 8)
  defp decode32(acc, charlist) do
    [char | remainder] = charlist
    decode32(acc, remainder, char)
  end
  defp decode32(acc, remainder, char) do
    mapped =
      case Map.fetch(decoding(), char) do
        {:ok, mapped} -> mapped
        :error        -> raise(UnknownCharacterError, <<char>>)
      end

    <<_::3, data::5>> = :binary.encode_unsigned(mapped)

    decode32(<<(acc::bits), data::5>>, remainder)
  end
end
