defmodule VdPec2.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      VdPec2Web.Telemetry,
      {DNSCluster, query: Application.get_env(:vd_pec2, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: VdPec2.PubSub},
      # Start a worker by calling: VdPec2.Worker.start_link(arg)
      # {VdPec2.Worker, arg},
      # Start to serve requests, typically the last entry
      VdPec2Web.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: VdPec2.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    VdPec2Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
