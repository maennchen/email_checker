# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for third-
# party users, it should be done in your mix.exs file.

# Sample configuration:
#
#     config :logger, :console,
#       level: :info,
#       format: "$date $time [$level] $metadata$message\n",
#       metadata: [:user_id]

## email_checker
# default_dns, :system_default | {non_neg_integer, non_neg_integer, non_neg_integer, non_neg_integer}
#  * This sets which DNS server to use by default
#  * default: :system_default (uses whatever is configured by default on the system)
# also_dns, [] | [{non_neg_integer, non_neg_integer, non_neg_integer, non_neg_integer}]
#  * This adds DNS servers to also check for name resolution
#  * default: []
# validations
#  * This allows a developer to constrain the validations that are run globally to a limited subset
#  * default: [Format, MX, SMTP]
# smtp_retries, non_neg_integer
#  * Maximum amount of retries to use during the SMTP validation strategy execution
#  * default: 2
# timeout_milliseconds, :infinity | non_neg_integer
#  * Maximum amount of time to use during MX or SMTP validation strategy executions
#  * timeout as non_neg_integer is in **milliseconds**
#  * default: :infinity
config :email_checker,
  default_dns: :system,
  also_dns: [],
  validations: [Format, MX],
  smtp_retries: 2,
  timeout_milliseconds: :infinity

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).

import_config "#{Mix.env}.exs"
