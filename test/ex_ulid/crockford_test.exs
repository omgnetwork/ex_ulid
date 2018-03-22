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
    test "returns the encoded value the same as `gbarr/Encode-Base32-Crockford` library" do
      assert "2" == encode32(2)
      assert "10" == encode32(32)
      assert "A0" == encode32(320)
      assert "AABBCCDD" == encode32(354715840941)
      assert "40" == encode32(128)
      assert "FM" == encode32(500)
    end

    # https://github.com/jbittel/base32-crockford/blob/master/test.py
    test "returns the encoded value the same as `jbittel/base32-crockford` library" do
      assert "16J" == encode32(1234)
    end

    # https://github.com/dflydev/dflydev-base32-crockford/blob/master/
    # tests/Dflydev/Base32/Crockford/CrockfordTest.php
    test "returns the encoded value the same as `dflydev/dflydev-base32-crockford` library" do
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

  # describe "decode32!/1" do
  #   test "returns the encoded value" do
  #     assert "" == decode32!("")
  #     assert "o" == decode32!("DW======")
  #     assert "om" == decode32!("DXPG====")
  #     assert "omi" == decode32!("DXPPJ===")
  #     assert "omis" == decode32!("DXPPJWR=")
  #     assert "omise" == decode32!("DXPPJWV5")
  #     assert "omiseg" == decode32!("DXPPJWV5CW======")
  #     assert "omisego" == decode32!("DXPPJWV5CXQG====")
  #     assert <<161, 178, 195, 212, 229, 246, 120, 145>> == decode32!("M6SC7N75YSW92===")

  #     assert <<161, 178, 195, 212, 229, 246, 120, 145>> ==
  #              decode32!("m6sc7n75ysw92===", case: :lower)

  #     assert <<161, 178, 195, 212, 229, 246, 120, 145>> ==
  #              decode32!("M6Sc7n75YsW92===", case: :mixed)
  #   end

  #   test "returns :error on non-alphabet digit" do
  #     assert :error == decode32("66KF")
  #     assert :error == decode32("66ff")
  #     assert :error == decode32("66FF", case: :lower)
  #   end
  # end
end
