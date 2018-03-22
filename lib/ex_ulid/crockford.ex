defmodule ExULID.Crockford do
  @moduledoc """
  This module provides data encoding and decoding functions
  according to [Crockford's Base32](http://www.crockford.com/wrmg/base32.html).
  """
  @encoding '0123456789ABCDEFGHJKMNPQRSTVWXYZ'
  @bits 5

  @spec encode32(binary | integer) :: binary
  def encode32(data) when is_integer(data) do
    data
    |> :binary.encode_unsigned()
    |> encode32()
  end
  # Pad or remove any leading zero
  def encode32(data) do
    data = pad_bitlength(data, @bits)
    encode32("", data)
  end
  # Ignore leading zeros unless it's the only character
  def encode32("", <<0::@bits>>), do: "0"
  def encode32("", <<0::@bits, remainder::bitstring>>), do: encode32("", remainder)
  # Main meaty part. Take the expected bits, convert to the encoding character,
  # then append the character to the accumulator.
  def encode32(acc, <<bits::@bits, remainder::bitstring>>) do
    acc
    |> Kernel.<>(<<Enum.at(@encoding, bits)>>)
    |> encode32(remainder)
  end
  # Last remainder will be an empty binary,
  # the accumulator is now final, return it as the result.
  def encode32(acc, <<>>), do: acc

  defp pad_bitlength(data, bitlength) when rem(bit_size(data), bitlength) == 0, do: data
  defp pad_bitlength(data, bitlength) when rem(bit_size(data), bitlength) > 0 do
    remainder = rem(bit_size(data), bitlength)
    <<a::size(remainder), remaining::bitstring>> = data

    if a > 0 do
      missing_bits = bitlength - remainder
      <<(<<0::size(missing_bits)>>), (data::binary)>>
    else
      <<remaining::bitstring>>
    end
  end
end
