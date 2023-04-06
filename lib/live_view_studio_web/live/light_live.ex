defmodule LiveViewStudioWeb.LightLive do
  # use Phoenix.LiveView
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    IO.inspect(self(), label: "MOUNT")
    socket = assign(socket, brightness: 10, temperature: "3000")
    {:ok, socket}
  end

  def render(assigns) do
    IO.inspect(self(), label: "RENDER")

    ~H"""
    <h1>Front porch Light</h1>
    <div id="light">
      <div class="meter">
        <span style={"width: #{@brightness}%; background: #{temp_color(@temperature)}"}>
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
      <form phx-change="update">
        <input
          type="range"
          min="0"
          max="100"
          name="brightness"
          value={@brightness}
        />
      </form>
      <form phx-change="change-temp">
        <div class="temps">
          <%= for temp <- ["3000", "4000", "5000"] do %>
            <div>
              <input
                id={temp}
                name="temperature"
                type="radio"
                value={temp}
                checked={temp == @temperature}
              />
              <label for={temp}><%= temp %></label>
            </div>
          <% end %>
        </div>
      </form>
    </div>
    """
  end

  def handle_event("change-temp", %{"temperature" => temperature}, socket) do
    socket = assign(socket, temperature: temperature)
    {:noreply, socket}
  end

  def handle_event("update", %{"brightness" => brightness}, socket) do
    {:noreply, assign(socket, brightness: String.to_integer(brightness))}
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

  defp temp_color("3000"), do: "#F1C40D"
  defp temp_color("4000"), do: "#FEFF66"
  defp temp_color("5000"), do: "#99CCFF"
end
