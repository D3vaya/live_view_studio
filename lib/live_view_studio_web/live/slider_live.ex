defmodule LiveViewStudioWeb.SliderLive do
  use LiveViewStudioWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, brightness: 10)}
  end

  def render(assigns) do
    ~H"""
    <form phx-change="update">
      <input
        type="range"
        min="0"
        max="100"
        name="brightness"
        value={@brightness}
      />
    </form>
    """
  end

  def handle_event("update", %{"brightness" => brightness}, socket) do
    {:noreply, assign(socket, brightness: String.to_integer(brightness))}
  end
end
