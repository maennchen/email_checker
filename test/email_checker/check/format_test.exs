defmodule EmailChecker.Check.FormatTest do
  use ExUnit.Case
  doctest EmailChecker.Check.Format

  describe "valid?" do
    for email <- ["user@domain.com", "user+addition@domain.com", "user.name+addition@domain.com"] do
      test "#{email} format returns true" do
        assert true == EmailChecker.Check.Format.valid?(unquote(email))
      end
    end

    for email <- ["user.domain.com", "test@gmail..", "test@gmail.com.."] do
      test "#{email} format returns false" do
        refute EmailChecker.Check.Format.valid?(unquote(email))
      end
    end
  end
end
