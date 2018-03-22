defmodule ExULID.UUIDTest do
  use ExUnit.Case
  import ExULID.ULID

  describe "generate/0" do
    # test "returns a ULID with the current timestamp" do
    #   ulid = generate()
    #   time = decode_time(ulid)
    #   current_time = :os.system_time(:milli_seconds)

    #   # The timestamp should be within 1 second of the current time
    #   assert time > current_time - 1000
    #   assert time < current_time + 1000
    # end
  end

  describe "generate_at/1" do
    test "returns a ULID with 26 characters" do
      ulid = generate()
      assert 26 == String.length(ulid)
    end

    # test "returns a ULID for the given timestamp" do
    #   time = :os.system_time(:milli_seconds)
    #   ulid = generate_at(time)
    #   assert time == decode_time(ulid)
    # end

    # https://github.com/ulid/javascript/blob/master/test.js
    test "returns expected encoded result" do
      assert "01ARYZ6S41" == encode_formatted(1469918176385, 10)
    end

    # https://github.com/ulid/javascript/blob/master/test.js
    test "returns zero-padded result" do
      assert "0001AS99AA60" == encode_formatted(1470264322240, 12)
    end

    # https://github.com/ulid/javascript/blob/master/test.js
    test "returns truncated time if not enough length" do
      assert "AS4Y1E11" == encode_formatted(1470118279201, 8)
    end
  end

  # describe "decode/1" do
  #   test "returns a tuple of timestamp and random string" do
  #     assert {1469918176385, "SV34QZB5B47GXAJ0"} == decode("01ARYZ6S41SV34QZB5B47GXAJ0")
  #   end
  # end

  # describe "decode_time/1" do
  #   test "returns the correct timestamp" do
  #     assert 1469918176385 == decode_time("01ARYZ6S41SV34QZB5B47GXAJ0")
  #   end

  #   test "accepts the maximum allowed timestamp" do
  #     assert 281474976710655 == decode_time("7ZZZZZZZZZZZZZZZZZZZZZZZZZ")
  #   end
  # end
end
