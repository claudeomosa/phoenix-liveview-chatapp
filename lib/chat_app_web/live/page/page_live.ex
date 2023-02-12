defmodule ChatAppWeb.PageLive do
  use ChatAppWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
      "hello live"
    """
  end
end
