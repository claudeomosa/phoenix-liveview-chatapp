defmodule ChatAppWeb.RoomLive do
  use ChatAppWeb, :live_view
  require Logger

  @impl true
  def mount(%{"id" => room_id}, _session, socket) do
    topic = "room" <> room_id
    username = MnemonicSlugs.generate_slug(2)
    if connected?(socket), do: ChatAppWeb.Endpoint.subscribe(topic)
   {:ok, 
    assign(socket,
        room_id: room_id,
        topic: topic,
        message: "",
        messages: [%{uuid: UUID.uuid4(), text: "#{username} joined the chat", username: "user"}],
        temporary_assigns: [messages: []],
        username: username
      )
    }
  end

  @impl true
  def handle_event("submit_message", %{"chat" => %{"message" => message}}, socket) do
    message = %{uuid: UUID.uuid4(), text: message, username: socket.assigns.username}
    ChatAppWeb.Endpoint.broadcast(socket.assigns.topic, "new-message", message)
    # {:reply, %{"message": message}, socket}
    {:noreply, assign(socket, message: "")}
  end

  @impl true
  def handle_event("form_update", %{"chat" => %{"message" => message}}, socket) do
     Logger.info(message: message)
      {:noreply, assign(socket, message: message)}
  end
  @impl true
  def handle_info(%{event: "new-message", payload: message}, socket) do
    Logger.info(payload: message)
    {:noreply, assign(socket, messages: [message])}
  end
end 
