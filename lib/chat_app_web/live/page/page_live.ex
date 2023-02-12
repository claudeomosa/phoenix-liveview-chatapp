defmodule ChatAppWeb.PageLive do
  use ChatAppWeb, :live_view
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", result: %{})}
  end

  @impl true
  def handle_event("random-room", _params, socket) do
    Logger.info("click!")
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
      <button title="start a room" phx-click="random-room">Start Room</button>
    """
  end
 end
