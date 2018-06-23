defmodule ExULID.Ecto.ULIDTest do
  use ExUnit.Case, async: true
  alias ExULID.Ecto.ULID

  @test_ulid "01C9GJZZ3D530PE8Q0ZYV5HJ9K"
  @test_ulid_too_short "1234567890123456789012345"
  @test_ulid_too_long "123456789012345678901234567"
  @test_ulid_binary <<1, 98, 97, 47, 252, 109, 40, 193,
                      103, 34, 224, 255, 182, 88, 201, 51>>

  describe "cast/1" do
    test "returns string ULID when given string ULID" do
      assert {:ok, @test_ulid} == ULID.cast(@test_ulid)
    end

    test "returns string ULID when given binary ULID" do
      assert {:ok, @test_ulid} == ULID.cast(@test_ulid_binary)
    end

    test "returns :error when given ULID with too few characters" do
      assert :error = ULID.cast(@test_ulid_too_short)
    end

    test "returns :error when given ULID with too many characters" do
      assert :error = ULID.cast(@test_ulid_too_long)
    end

    test "returns :error when given an empty string" do
      assert :error = ULID.cast("")
    end

    test "returns :error when given nil" do
      assert :error = ULID.cast(nil)
    end
  end

  describe "load/1" do
    test "returns {:ok, string_ulid} when given a binary ULID" do
      assert {:ok, @test_ulid} = ULID.load(@test_ulid_binary)
    end

    test "returns :error when given an empty string" do
      assert :error = ULID.load("")
    end
  end

  describe "dump/1" do
    test "returns {:ok, binary_uuid} when given a string ULID" do
      assert {:ok, @test_ulid_binary} == ULID.dump(@test_ulid)
    end

    test "returns :error when given a binary ULID" do # `cast/1` always return a string ULID
      assert :error = ULID.dump(@test_ulid_binary)
    end
  end

  describe "generate/0" do
    test "returns a string ULID" do
      assert <<_::bytes-size(10), _::bytes-size(16)>> = ULID.generate()
    end
  end
end
