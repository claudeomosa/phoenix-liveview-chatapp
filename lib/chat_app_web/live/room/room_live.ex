defmodule ChatAppWeb.RoomLive do
  use ChatAppWeb, :live_view
  require Logger

  @impl true
  def mount(%{"id" => room_id}, _session, socket) do
    topic = "room" <> room_id
    username = MnemonicSlugs.generate_slug(2)
    if connected?(socket) do
      ChatAppWeb.Endpoint.subscribe(topic)
      ChatAppWeb.Presence.track(self(), topic, username, %{})
    end
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
    
    {:noreply, assign(socket, messages: [message])}
  end

  @impl true
  def handle_info(%{event: "presence_diff", payload: %{joins: joins, leaves: leaves}}, socket) do
    join_messages = 
      joins 
      |> Map.keys()
      |> Enum.map(fn username -> %{uuid: UUID.uuid4(), text: "#{username} joined the chat", username: "user"} end)
    leave_messages = 
      leaves 
      |> Map.keys()
      |> Enum.map(fn username -> %{uuid: UUID.uuid4(), text: "#{username} left the chart", username: username} end)
    {:noreply, assign(socket, messages: join_messages ++ leave_messages)}
  end
end 
