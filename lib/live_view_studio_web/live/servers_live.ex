defmodule LiveViewStudioWeb.ServersLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Servers

  def mount(_params, _session, socket) do
    IO.inspect(self(), label: "MOUNT")
    servers = Servers.list_servers()

    socket =
      assign(socket,
        servers: servers,
        coffees: 0
      )

    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    IO.inspect(self(), label: "HANDLE PARAMS ID=#{id}")
    server = Servers.get_server!(id)

    {:noreply,
     assign(socket,
       selected_server: server,
       page_title: "What's up"
     )}
  end

  def handle_params(_params, _url, socket) do
    IO.inspect(self(), label: "HANDLE PARAMS CATCH")

    {:noreply,
     assign(socket,
       selected_server: hd(socket.assigns.servers)
     )}
  end

  def render(assigns) do
    IO.inspect(self(), label: "RENDER")

    ~H"""
    <h1>Servers</h1>
    <div id="servers">
      <div class="sidebar">
        <div class="nav">
          <.link
            :for={server <- @servers}
            patch={~p"/servers/#{server}"}
            class={if server == @selected_server, do: "selected"}
          >
            <span class={server.status}></span>
            <%= server.name %>
          </.link>
        </div>
        <div class="coffees">
          <button phx-click="drink">
            <img src="/images/coffee.svg" />
            <%= @coffees %>
          </button>
        </div>
      </div>
      <.server server={@selected_server} />
    </div>
    """
  end

  attr :server, LiveViewStudio.Servers.Server, required: true

  def server(assigns) do
    ~H"""
    <div class="main">
      <div class="wrapper">
        <div class="server">
          <div class="header">
            <h2><%= @server.name %></h2>
            <span class={@server.status}>
              <%= @server.status %>
            </span>
          </div>
          <div class="body">
            <div class="row">
              <span>
                <%= @server.deploy_count %> deploys
              </span>
              <span>
                <%= @server.size %> MB
              </span>
              <span>
                <%= @server.framework %>
              </span>
            </div>
            <h3>Last Commit Message:</h3>
            <blockquote>
              <%= @server.last_commit_message %>
            </blockquote>
          </div>
        </div>
        <div class="links">
          <.link navigate={~p"/light"}>
            Adjunt Lights
          </.link>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("drink", _, socket) do
    IO.inspect(self(), label: "DRINK EVENT")
    {:noreply, update(socket, :coffees, &(&1 + 1))}
  end
end
