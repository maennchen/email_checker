defmodule EmailChecker.Loader do
  @moduledoc false

  use Application

  defp default_dns do
    Application.get_env(:email_checker, :default_dns, :system)
  end

  defp also_dns do
    Application.get_env(:email_checker, :also_dns, [])
  end

  defp insert_ns(ns = {w, x, y, z})
    when is_integer(w) and is_integer(x) and is_integer(y) and is_integer(z)
  do
    :ok = :inet_db.ins_ns(ns)
  end

  defp append_ns(ns = {w, x, y, z})
    when is_integer(w) and is_integer(x) and is_integer(y) and is_integer(z)
  do
    # Append the specified dns server at the end of the nameserver list
    :ok = :inet_db.add_ns(ns)
  end

  @spec start(Application.start_type, start_args :: term) ::
      {:ok, pid} |
      {:ok, pid, Application.state} |
      {:error, reason :: term}
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    unless default_dns() == :system, do: insert_ns(default_dns())

    # HACK: add a default and "also" DNS when `inet_db` is not yet available
    # http://stackoverflow.com/questions/33811899/elixir-errors-using-inet-res-library#comment55418047_33811899
    if is_list(also_dns()), do: Enum.each(also_dns(), &append_ns/1)

    Supervisor.start_link([], strategy: :one_for_one, name: :email_checker)
  end
end
