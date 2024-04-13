import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :vd_pec2, VdPec2Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "7E4J3LnBEy5NUXscA3Ge7PvDNjD82B1A1EXWvhKKZHt7hrcBxR/hNqihVj9FAHOI",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
