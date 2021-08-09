# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :employee_reward_app,
  ecto_repos: [EmployeeRewardApp.Repo]

# Configures the endpoint
config :employee_reward_app, EmployeeRewardAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "bAWoV025XjlPW5gh2SNAM+YWZxqcibH9s95JLypzAykKAMO34oBjCY8KzoXY4pRe",
  render_errors: [view: EmployeeRewardAppWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: EmployeeRewardApp.PubSub,
  live_view: [signing_salt: "+dPQmmqt"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Default values for employee_reward_app
config :employee_reward_app, start_points_pool: 50

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
