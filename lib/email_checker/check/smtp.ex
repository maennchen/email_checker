if match?({:module, Socket.TCP}, Code.ensure_compiled(Socket.TCP)) do
  defmodule EmailChecker.Check.SMTP do
    @moduledoc """
    Check if an emails server is aknowledging an email address.
    """

    @behaviour EmailChecker.Check

    alias EmailChecker.Tools
    alias Socket.TCP
    alias Socket.Stream

    @doc """
    Check if an emails server is aknowledging an email address.

    ## Parameters

      * `email` - `binary` - the email to check
      * `retries` - `non_neg_integer` - max retries (default from config)

    ## Example

        iex> EmailChecker.Check.SMTP.valid?("test@gmail.com")
        false

    """
    @spec valid?(String.t(), non_neg_integer) :: boolean
    def valid?(email, retries \\ max_retries())
    def valid?(_, 0), do: false

    def valid?(email, retries) do
      case smtp_reply(email) do
        nil ->
          false

        response ->
          Regex.match?(~r/^250 /, response)
      end
    rescue
      Socket.Error ->
        valid?(email, retries - 1)

      _ ->
        false
    end

    defp mx_address(email) do
      email
      |> Tools.domain_name()
      |> Tools.lookup()
    end

    defp timeout_opt do
      case max_timeout() do
        :infinity ->
          :infinity

        t when is_integer(t) ->
          t |> div(max_retries()) |> abs
      end
    end

    defp smtp_reply(email) do
      opts = [packet: :line, timeout: timeout_opt()]

      socket =
        email
        |> mx_address
        |> TCP.connect!(25, opts)

      socket |> Stream.recv!()

      socket |> Stream.send!("HELO #{Tools.domain_name(email)}\r\n")
      socket |> Stream.recv!()

      socket |> Stream.send!("mail from:<fake@email.com>\r\n")
      socket |> Stream.recv!()

      socket |> Stream.send!("rcpt to:<#{email}>\r\n")
      socket |> Stream.recv!()
    end

    defp max_retries, do: Application.get_env(:email_checker, :smtp_retries, 2)
    defp max_timeout, do: Application.get_env(:email_checker, :timeout_milliseconds, :infinity)
  end
end
