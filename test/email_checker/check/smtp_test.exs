defmodule EmailChecker.Check.SMTPTest do
  use EmailChecker.SMTPCase, async: false
  doctest EmailChecker.Check.Format

  describe "valid?" do
    test "a valid SMTP record returns true" do
      with_mocks valid_mock() do
        assert true == EmailChecker.Check.SMTP.valid?("kevin@disneur.me")
      end
    end

    test "an invalid SMTP record returns false" do
      with_mocks invalid_mock() do
        assert false == EmailChecker.Check.SMTP.valid?("non-existing@disneur.me")
      end
    end
  end
end
