defmodule EmailChecker.Check.MXTest do
  use ExUnit.Case
  doctest EmailChecker.Check.Format

  describe "valid?" do
    test "a valid MX record returns true" do
      assert true == EmailChecker.Check.MX.valid?("kevin@disneur.me")
      assert true == EmailChecker.Check.MX.valid?("non-existing-user@disneur.me")
    end

    test "an invalid MX record returns false" do
      assert false == EmailChecker.Check.MX.valid?("john@invalid-mx-domain.tld")
    end
  end
end
