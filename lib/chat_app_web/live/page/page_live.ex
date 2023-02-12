defmodule ChatAppWeb.PageLive do
  use ChatAppWeb, :live_view
  require Logger

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, query: "", result: %{})}
  end

  @impl true
  def handle_event("random-room", _params, socket) do
    random_slug = "/" <> MnemonicSlugs.generate_slug(2)
    {:noreply, push_redirect(socket, to: random_slug)}
  end

  def render(assigns) do
    ~H"""
      <button title="start a room" phx-click="random-room">Start Room</button>
    """
  end
 end
