defmodule ExULID.CrockfordTest do
  use ExUnit.Case
  import ExULID.Crockford

  describe "encode32/1" do
    test "returns the encoded string" do
      assert {:ok, ""} == encode32("")
      assert {:ok, "3F"} == encode32("o")
      assert {:ok, "VVD"} == encode32("om")
      assert {:ok, "6YVB9"} == encode32("omi")
      assert {:ok, "1QPTTBK"} == encode32("omis")
      assert {:ok, "DXPPJWV5"} == encode32("omise")
      assert {:ok, "3FDNMQ6SB7"} == encode32("omiseg")
      assert {:ok, "VVDD5SPASVF"} == encode32("omisego")
    end

    test "returns the encoded binary" do
      assert {:ok, "A3CP3TKJZCY4H"} == encode32(<<161, 178, 195, 212, 229, 246, 120, 145>>)
    end

    test "returns the encoded value for an 80-bit binary" do
      assert {:ok, "PJS32CNANR186SDJ"} ==
               encode32(<<180, 178, 49, 50, 170, 174, 2, 131, 101, 178>>)
    end

    test "returns empty string when given empty string" do
      assert {:ok, ""} == encode32("")
    end

    # https://github.com/gbarr/Encode-Base32-Crockford/blob/master/t/base32.t
    test "returns the same encoded values as `gbarr/Encode-Base32-Crockford` library" do
      assert {:ok, "2"} == encode32(2)
      assert {:ok, "10"} == encode32(32)
      assert {:ok, "A0"} == encode32(320)
      assert {:ok, "AABBCCDD"} == encode32(354715840941)
      assert {:ok, "40"} == encode32(128)
      assert {:ok, "FM"} == encode32(500)
    end

    # https://github.com/jbittel/base32-crockford/blob/master/test.py
    test "returns the same encoded values as `jbittel/base32-crockford` library" do
      assert {:ok, "16J"} == encode32(1234)
    end

    # https://github.com/dflydev/dflydev-base32-crockford/blob/master/
    # tests/Dflydev/Base32/Crockford/CrockfordTest.php
    test "returns the same encoded value as `dflydev/dflydev-base32-crockford` library" do
      assert {:ok, "0"} == encode32(0)
      assert {:ok, "1"} == encode32(1)
      assert {:ok, "2"} == encode32(2)
      assert {:ok, "62"} == encode32(194)
      assert {:ok, "DY2N"} == encode32(456789)
      assert {:ok, "C515"} == encode32(398373)
      assert {:ok, "FVCK"} == encode32(519571)
      assert {:ok, "3D2ZQ6TVC93"} == encode32(3838385658376483)
    end
  end

  describe "decode32/1" do
    test "returns the encoded value" do
      assert {:ok, ""} == decode32("")
      assert {:ok, "o"} == decode32("3F")
      assert {:ok, "om"} == decode32("VVD")
      assert {:ok, "omi"} == decode32("6YVB9")
      assert {:ok, "omis"} == decode32("1QPTTBK")
      assert {:ok, "omise"} == decode32("DXPPJWV5")
      assert {:ok, "omiseg"} == decode32("3FDNMQ6SB7")
      assert {:ok, "omisego"} == decode32("VVDD5SPASVF")
    end

    # https://github.com/gbarr/Encode-Base32-Crockford/blob/master/t/base32.t
    test "returns the same decoded values as `gbarr/Encode-Base32-Crockford` library" do
      assert {:ok, binary_of(2)} == decode32("2")
      assert {:ok, binary_of(32)} == decode32("10")
      assert {:ok, binary_of(320)} == decode32("A0")
      assert {:ok, binary_of(354715840941)} == decode32("AABBCCDD")
      assert {:ok, binary_of(128)} == decode32("40")
      assert {:ok, binary_of(500)} == decode32("FM")
    end

    # https://github.com/jbittel/base32-crockford/blob/master/test.py
    test "returns the same decoded values as `jbittel/base32-crockford` library" do
      assert {:ok, :binary.encode_unsigned(1234)} == decode32("16J")
    end

    # https://github.com/dflydev/dflydev-base32-crockford/blob/master/
    # tests/Dflydev/Base32/Crockford/CrockfordTest.php
    test "returns the same decoded value as `dflydev/dflydev-base32-crockford` library" do
      assert {:ok, binary_of(0)} == decode32("0")
      assert {:ok, binary_of(1)} == decode32("1")
      assert {:ok, binary_of(2)} == decode32("2")
      assert {:ok, binary_of(194)} == decode32("62")
      assert {:ok, binary_of(456789)} == decode32("DY2N")
      assert {:ok, binary_of(398373)} == decode32("C515")
      assert {:ok, binary_of(519571)} == decode32("FVCK")
      assert {:ok, binary_of(3838385658376483)} == decode32("3D2ZQ6TVC93")
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
