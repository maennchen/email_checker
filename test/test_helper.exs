defmodule EmailChecker.TestEnv do

  def setup_default_application_env do

    # Deviate from the default of :system here, since tests load and run so
    # quickly, that a specific DNS server being inserted is practically required.
    Application.put_env(:email_checker, :default_dns, {8, 8, 8, 8})
    Application.put_env(:email_checker, :also_dns, [{8, 8, 4, 4}])

    Application.put_env(:email_checker, :validations, [EmailChecker.Check.Format, EmailChecker.Check.MX, EmailChecker.Check.SMTP])

    Application.put_env(:email_checker, :smtp_retries, 2)
    Application.put_env(:email_checker, :timeout_milliseconds, :infinity)

    :ok
  end

end

Application.put_env(:email_checker, :validations, [EmailChecker.Check.Format])

ExUnit.start()
