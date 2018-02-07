defmodule EmailChecker.SMTPCase do
  @moduledoc """
  This EXUnit Case Example is made to (very cheaply) mock an SMTP Socket
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      import Mock

      @doc """
      Generate a Mock for a Valid SMTP Response
      """
      def valid_mock do
        EmailChecker.SMTPCase.mock(fn _ -> "250 Something" end)
      end

      @doc """
      Generate a Mock for an Invalid SMTP Response
      """
      def invalid_mock do
        EmailChecker.SMTPCase.mock(fn _ -> nil end)
      end
    end
  end

  @doc """
  Get Mock Configuration

  Parameters:
   * `recv` - A function to replace `Socket.Stream.recv!`
  """
  def mock(recv) do
    [
      {
        Socket.TCP,
        [],
        [connect!: fn _, _, _ -> nil end]
      },
      {
        Socket.Stream,
        [],
        [
          send!: fn _, _ -> nil end,
          recv!: recv
        ]
      }
    ]
  end
end
