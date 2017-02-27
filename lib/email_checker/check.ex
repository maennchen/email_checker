defmodule EmailChecker.Check do
  @moduledoc """
  Bahaviour for all Checks
  """

  @callback valid?(String.t) :: boolean
end
