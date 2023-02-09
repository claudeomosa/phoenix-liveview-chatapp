import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :chat_app, ChatAppWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "TjJ/EVwD8KYq1l2QIK9H8y92NvUlQNNosYXMTkTVUVbpfAOM2hwHXh1eZdXuPX2J",
  server: false

# In test we don't send emails.
config :chat_app, ChatApp.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
