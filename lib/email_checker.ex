defmodule EmailChecker do
  @moduledoc """
  Simple library checking the validity of an email.

  ## Checks (in order)
    * REGEX: validate the emails has a good looking format
    * MX: validate the domain sever contains MX records
    * SMTP: validate the SMTP behind the MX records knows this email address (no email sent; disabled by default)
  """

  @doc """
  Check a given Email

  ## Parameters

    * `email` - `binary` - the email to check
    * `validations` - `function[]` - the checks to use (default from config)

  ## Example

      iex> EmailChecker.valid?("test@test.ch", [EmailChecker.Check.Format])
      true

  """
  @spec valid?(String.t, [EmailChecker.Check]) :: boolean
  def valid?(email, validations \\ configured_validations())
  def valid?(email, [validation | tail]) do
    if validation.valid?(email) do
      valid?(email, tail)
    else
      false
    end
  end
  def valid?(_, []), do: true

  defp configured_validations do
    Application.get_env(:email_checker, :validations, [EmailChecker.Check.Format, EmailChecker.Check.MX])
  end
end
