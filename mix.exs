defmodule EmailChecker.Mixfile do
  use Mix.Project

  @version "0.2.4"

  def project do
    [
      app: :email_checker,
      version: @version,
      elixir: "~> 1.3",
      elixirc_paths: elixirc_paths(Mix.env()),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls],
      description: description(),
      package: package(),
      deps: deps(),
      dialyzer:
        [
          list_unused_filters: true,
          plt_add_apps: [:mix]
        ] ++
          if System.get_env("DIALYZER_PLT_PRIV", "false") in ["1", "true"] do
            [plt_file: {:no_warn, "priv/plts/dialyzer.plt"}]
          else
            []
          end,
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.html": :test,
        "coveralls.json": :test,
        "coveralls.post": :test,
        "coveralls.xml": :test
      ]
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [
      mod: {EmailChecker.Loader, []},
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

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
    [
      {:socket, "~> 0.3.1", optional: true},
      {:mock, "~> 0.2", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:credo, "~> 1.6", only: :dev},
      {:excoveralls, "~> 0.4", runtime: false, only: [:test]},
      {:dialyxir, "~> 1.0", runtime: false, only: [:dev]}
    ]
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
      files: ["lib", "mix.exs", "README*", "LICENSE*", "priv"],
      maintainers: ["Kevin Disneur"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/maennchen/email_checker"
      }
    ]
  end
end
