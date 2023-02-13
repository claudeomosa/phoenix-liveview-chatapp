defmodule ChatAppWeb.RoomLive do
  use ChatAppWeb, :live_view
  require Logger

  @impl true
  def mount(%{"id" => room_id}, _session, socket) do
    topic = "room" <> room_id
    if connected?(socket), do: ChatAppWeb.Endpoint.subscribe(topic)
   {:ok, assign(socket, room_id: room_id, topic: topic, messages: ["hello, world", "are you ok"], temporary_assigns: [messages: []])}
  end

  @impl true
  def handle_event("submit_message", %{"chat" => %{"message" => message}}, socket) do
    Logger.info(message: message)
    ChatAppWeb.Endpoint.broadcast(socket.assigns.topic, "new-message", message)
    # {:reply, %{"message": message}, socket}
    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "new-message", payload: message}, socket) do
    Logger.info(payload: message)
    {:noreply, assign(socket, messages: [message])}
  end
end 
