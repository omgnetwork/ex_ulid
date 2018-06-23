defmodule ExULID.UUIDTest do
  use ExUnit.Case, async: true
  import ExULID.ULID

  describe "generate/0" do
    test "returns a ULID with 26 characters" do
      {:ok, ulid} = generate()
      assert 26 == String.length(ulid)
    end

    test "returns a ULID with the current timestamp" do
      {:ok, ulid}          = generate()
      {time, _rand}        = decode(ulid)
      confidence_threshold = 100 # 0.1 seconds

      # We can't be sure of the exact millisecond used inside generate/1
      # but we can consider it acceptable if the timestamp produced is
      # within a specific range.
      assert time > :os.system_time(:milli_seconds) - confidence_threshold
      assert time < :os.system_time(:milli_seconds) + confidence_threshold
    end
  end

  describe "generate/1" do
    # https://github.com/ulid/javascript/blob/master/test.js
    test "returns the expected encoded time component" do
      assert {:ok, "01ARYZ6S41" <> _} = generate(1469918176385)
    end

    # https://github.com/ulid/javascript/blob/master/test.js (test value edited)
    test "returns zero-padded result" do
      assert {:ok, "0000000001" <> _} = generate(1)
    end
  end

  describe "encode_time/2" do
    test "throws error if time is greater than (2 ^ 48) - 1" do
      overflowed_time =
        2
        |> :math.pow(48)
        |> round()

      assert {:error, "time cannot be >= 2^48 milliseconds, got 281474976710656"} = generate(overflowed_time)
    end

    test "throws error if time is not an integer" do
      assert {:error, ~s(time must be an integer, got "string")} = generate("string")
      assert {:error, ~s(time must be an integer, got "123456")} = generate("123456")
      assert {:error, ~s(time must be an integer, got 100.1)} = generate(100.1)
    end

    test "throws error if time is negative" do
      assert {:error, "time cannot be negative, got -1"} = generate(-1)
    end
  end

  describe "decode/1" do
    # https://github.com/ulid/javascript/blob/master/test.js
    test "returns a tuple of timestamp and random string" do
      assert {1469918176385, "SV34QZB5B47GXAJ0"} == decode("01ARYZ6S41SV34QZB5B47GXAJ0")
    end

    test "returns the correct timestamp" do
      assert {1469918176385, _} = decode("01ARYZ6S41SV34QZB5B47GXAJ0")
    end

    # https://github.com/ulid/javascript/blob/master/test.js
    test "accepts the maximum allowed timestamp ((2 ^ 48) - 1)" do
      assert {281474976710655, _} = decode("7ZZZZZZZZZZZZZZZZZZZZZZZZZ")
    end

    # https://github.com/ulid/javascript/blob/master/test.js
    test "rejects malformed strings of incorrect length" do
      assert {:error, ~s(the ULID must be 26 characters long, got "FFFF")} == decode("FFFF")
    end

    # https://github.com/ulid/javascript/blob/master/test.js
    test "rejects strings with timestamps too high" do
      assert {:error, "the decoded time cannot be greater than 2^48, got 281474976710656"}
        == decode("80000000000000000000000000")
    end
  end
end
