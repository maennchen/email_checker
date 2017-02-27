defmodule EmailChecker.Mixfile do
  use Mix.Project

  def project do
    [app: :email_checker,
     version: "0.0.3",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     test_coverage: [tool: ExCoveralls],
     description: description(),
     package: package(),
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      mod: {EmailChecker.Loader, []},
      applications: [:logger, :socket]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:socket, "~> 0.3.1"},
     {:mock, "~> 0.2.0", only: :test},
     {:inch_ex, only: :docs},
     {:excoveralls, "~> 0.6", only: :test}]
  end

  defp description do
    """
    Simple library checking the validity of an email. Checks are performed in the following order:

    - REGEX: validate the emails has a good looking format

    - MX: validate the domain sever contains MX records

    - SMTP: validate the SMTP behind the MX records knows this email address (no email sent)
    """
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README*", "LICENSE*"],
      maintainers: ["Kevin Disneur"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/kdisneur/email_checker"
      }
    ]
  end
end
