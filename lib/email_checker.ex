defmodule EmailChecker do

  defp configured_validations do
    strategies = Application.get_env(:email_checker, :validations, [Format, MX])
    for strategy <- strategies, do: &Module.concat(EmailChecker, strategy).valid?/1
  end

  def valid?(email, validations \\ configured_validations())
  def valid?(email, [validation | tail]) do
    if validation.(email) do
      valid?(email, tail)
    else
      false
    end
  end
  def valid?(_, []), do: true
end
