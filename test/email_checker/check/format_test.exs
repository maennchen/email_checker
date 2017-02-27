defmodule EmailChecker.Check.FormatTest do
  use ExUnit.Case
  doctest EmailChecker.Check.Format

  describe "valid?" do
    test "a valid email format returns true" do
      assert true == EmailChecker.Check.Format.valid?("user@domain.com")
      assert true == EmailChecker.Check.Format.valid?("user+addition@domain.com")
      assert true == EmailChecker.Check.Format.valid?("user.name+addition@domain.com")
    end

    test "an invalid email format returns false" do
      assert false == EmailChecker.Check.Format.valid?("user.domain.com")
      assert false == EmailChecker.Check.Format.valid?("user name@domain.com")
    end
  end
end
