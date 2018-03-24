defmodule ExULID.CrockfordTest do
  use ExUnit.Case
  import ExULID.Crockford

  describe "encode32/1" do
    test "returns the encoded string" do
      assert "" == encode32("")
      assert "3F" == encode32("o")
      assert "VVD" == encode32("om")
      assert "6YVB9" == encode32("omi")
      assert "1QPTTBK" == encode32("omis")
      assert "DXPPJWV5" == encode32("omise")
      assert "3FDNMQ6SB7" == encode32("omiseg")
      assert "VVDD5SPASVF" == encode32("omisego")
    end

    test "returns the encoded binary" do
      assert "A3CP3TKJZCY4H" == encode32(<<161, 178, 195, 212, 229, 246, 120, 145>>)
    end

    test "returns the encoded value for an 80-bit binary" do
      assert "PJS32CNANR186SDJ" ==
               encode32(<<180, 178, 49, 50, 170, 174, 2, 131, 101, 178>>)
    end

    test "returns empty string when given empty string" do
      assert "" == encode32("")
    end

    # https://github.com/gbarr/Encode-Base32-Crockford/blob/master/t/base32.t
    test "returns the same encoded values as `gbarr/Encode-Base32-Crockford` library" do
      assert "2" == encode32(2)
      assert "10" == encode32(32)
      assert "A0" == encode32(320)
      assert "AABBCCDD" == encode32(354715840941)
      assert "40" == encode32(128)
      assert "FM" == encode32(500)
    end

    # https://github.com/jbittel/base32-crockford/blob/master/test.py
    test "returns the same encoded values as `jbittel/base32-crockford` library" do
      assert "16J" == encode32(1234)
    end

    # https://github.com/dflydev/dflydev-base32-crockford/blob/master/
    # tests/Dflydev/Base32/Crockford/CrockfordTest.php
    test "returns the same encoded value as `dflydev/dflydev-base32-crockford` library" do
      assert "0" == encode32(0)
      assert "1" == encode32(1)
      assert "2" == encode32(2)
      assert "62" == encode32(194)
      assert "DY2N" == encode32(456789)
      assert "C515" == encode32(398373)
      assert "FVCK" == encode32(519571)
      assert "3D2ZQ6TVC93" == encode32(3838385658376483)
    end
  end

  describe "decode32/1" do
    test "returns the encoded value" do
      assert "" == decode32("")
      assert "o" == decode32("3F")
      assert "om" == decode32("VVD")
      assert "omi" == decode32("6YVB9")
      assert "omis" == decode32("1QPTTBK")
      assert "omise" == decode32("DXPPJWV5")
      assert "omiseg" == decode32("3FDNMQ6SB7")
      assert "omisego" == decode32("VVDD5SPASVF")
    end

    # https://github.com/gbarr/Encode-Base32-Crockford/blob/master/t/base32.t
    test "returns the same decoded values as `gbarr/Encode-Base32-Crockford` library" do
      assert binary_of(2) == decode32("2")
      assert binary_of(32) == decode32("10")
      assert binary_of(320) == decode32("A0")
      assert binary_of(354715840941) == decode32("AABBCCDD")
      assert binary_of(128) == decode32("40")
      assert binary_of(500) == decode32("FM")
    end

    # https://github.com/jbittel/base32-crockford/blob/master/test.py
    test "returns the same decoded values as `jbittel/base32-crockford` library" do
      assert :binary.encode_unsigned(1234) == decode32("16J")
    end

    # https://github.com/dflydev/dflydev-base32-crockford/blob/master/
    # tests/Dflydev/Base32/Crockford/CrockfordTest.php
    test "returns the same decoded value as `dflydev/dflydev-base32-crockford` library" do
      assert binary_of(0) == decode32("0")
      assert binary_of(1) == decode32("1")
      assert binary_of(2) == decode32("2")
      assert binary_of(194) == decode32("62")
      assert binary_of(456789) == decode32("DY2N")
      assert binary_of(398373) == decode32("C515")
      assert binary_of(519571) == decode32("FVCK")
      assert binary_of(3838385658376483) == decode32("3D2ZQ6TVC93")
    end

    # Ref: https://github.com/ulid/spec
    test "returns :error on non-alphabet digit (I, L, O, and U)" do
      assert {:error, ~s(a character could not be decoded, got: "I")} = decode32("I")
      assert {:error, ~s(a character could not be decoded, got: "L")} = decode32("L")
      assert {:error, ~s(a character could not be decoded, got: "O")} = decode32("O")
      assert {:error, ~s(a character could not be decoded, got: "U")} = decode32("U")

      assert {:error, ~s(a character could not be decoded, got: "I")} = decode32("111IIIAAA")
    end
  end

  defp binary_of(integer), do: :binary.encode_unsigned(integer)
end
