defmodule EmailCheckerTest do
  use EmailChecker.SMTPCase, async: false
  doctest EmailChecker

  setup do
   EmailChecker.TestEnv.setup_default_application_env
  end

  test "valid?: an invalid email format returns false" do
    assert false == EmailChecker.valid?("invalid-email")
  end

  test "valid?: a non-existing MX returns false" do
    assert false == EmailChecker.valid?("john.doe@invalid-mx-domain.tld")
  end

  test "valid?: a non-existing email address returns false" do
    with_mocks invalid_mock() do
      assert false == EmailChecker.valid?("non-existent-user@disneur.me")
    end
  end

  test "valid?: an existing email address returns true" do
    with_mocks valid_mock() do
      assert true == EmailChecker.valid?("kevin@disneur.me")
    end
  end

  test "valid?: a known bad email only validated only for format as configured" do
    Application.put_env(:email_checker, :validations, [EmailChecker.Check.Format])
    assert true == EmailChecker.valid?("derp@asdf.com")
  end
end
