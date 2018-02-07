defmodule EmailChecker.TimeoutTest do
  use EmailChecker.SMTPCase, async: false

  setup do
    EmailChecker.TestEnv.setup_default_application_env()
  end

  # start/stop timer strategy ported from Erlang lib/kernel/src/inet.erl
  @spec stop_timer(nil) :: true
  @spec stop_timer(reference) :: boolean
  @spec start_timer(:infinity) :: nil
  @spec start_timer(non_neg_integer) :: reference

  defp start_timer(:infinity), do: nil
  defp start_timer(timeout), do: :erlang.start_timer(timeout, self(), :tooslow)

  defp stop_timer(nil), do: true

  defp stop_timer(timer) do
    case :erlang.cancel_timer(timer) do
      false ->
        # false, if the timer was unable to be canceled
        receive do
          {:timeout, _timer, _msg} -> false
        after
          0 -> false
        end

      _ ->
        # true, if the timer was able to be canceled
        true
    end
  end

  test "timeout: :infinity works for known good email address and servers" do
    with_mocks valid_mock() do
      timeout = :infinity
      Application.put_env(:email_checker, :timeout_milliseconds, timeout)
      Application.put_env(:email_checker, :smtp_retries, 1)

      timer = start_timer(timeout)
      result = EmailChecker.valid?("kevin@disneur.me")
      timer_not_fired = stop_timer(timer)

      assert timer_not_fired
      assert result
    end
  end

  test "timeout: non_neg_integer works for known good email address and servers" do
    with_mocks valid_mock() do
      timeout = 5000
      Application.put_env(:email_checker, :timeout_milliseconds, timeout)
      Application.put_env(:email_checker, :smtp_retries, 1)

      timer = start_timer(timeout)
      result = EmailChecker.valid?("kevin@disneur.me")
      timer_not_fired = stop_timer(timer)

      assert timer_not_fired
      assert result
    end
  end

  # Re-Enable if you know any bad server. asdf.com is not working anymore
  # test "timeout: non_neg_integer works to quickly return from checking a known bad email address or server" do
  #   timeout = 5000
  #   Application.put_env(:email_checker, :timeout_milliseconds, timeout)
  #   Application.put_env(:email_checker, :smtp_retries, 1)
  #
  #   timer = start_timer(timeout)
  #   _ = EmailChecker.valid? "derp@asdf.com"
  #   timer_not_fired = stop_timer(timer)
  #
  #   assert !timer_not_fired
  # end
end
