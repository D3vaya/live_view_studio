defmodule LiveViewStudioWeb.LightLive do
  # use Phoenix.LiveView
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    IO.inspect(self(), label: "MOUNT")
    socket = assign(socket, brightness: 10)
    {:ok, socket}
  end

  def render(assigns) do
    IO.inspect(self(), label: "RENDER")

    ~H"""
    <h1>Front porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style={"width: #{@brightness}%"}>
          <%= @brightness %>%
        </span>
      </div>
      <button phx-click="off">
        <img src="/images/light-off.svg" />
      </button>
      <button phx-click="down">
        <img src="/images/down.svg" />
      </button>
      <button phx-click="random">
        <img src="/images/fire.svg" />
      </button>
      <button phx-click="up">
        <img src="/images/up.svg" />
      </button>
      <button phx-click="on">
        <img src="/images/light-on.svg" />
      </button>
    </div>
    """
  end

  def handle_event("on", _, socket) do
    IO.inspect(self(), label: "ON")

    {:noreply, assign(socket, brightness: 100)}
  end

  def handle_event("off", _, socket) do
    {:noreply, assign(socket, brightness: 0)}
  end

  def handle_event("up", _, socket) do
    socket = update(socket, :brightness, &min(&1 + 10, 100))
    {:noreply, socket}
  end

  def handle_event("down", _, socket) do
    socket = update(socket, :brightness, &max(&1 - 10, 0))
    {:noreply, socket}
  end

  def handle_event("random", _, socket) do
    {:noreply, assign(socket, brightness: Enum.random(0..100))}
  end
end
