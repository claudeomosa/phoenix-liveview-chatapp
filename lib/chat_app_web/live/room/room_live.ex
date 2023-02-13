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
        messages: [],
        temporary_assigns: [messages: []],
        username: username,
        online_users: []
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
      |> Enum.map(fn username -> %{type: :system, uuid: UUID.uuid4(), text: "#{username} joined the chat"} end)
    leave_messages = 
      leaves 
      |> Map.keys()
      |> Enum.map(fn username -> %{type: :system, uuid: UUID.uuid4(), text: "#{username} left the chart"} end)
    online_users = ChatAppWeb.Presence.list(socket.assigns.topic) |> Map.keys()

    Logger.info(online_users)
    {:noreply, assign(socket, messages: join_messages ++ leave_messages, online_users: online_users)}
  end
  def display_message(%{type: :system, uuid: uuid, text: text}) do
    ~E"""
    <p id="<%= uuid%>" class="italic">
      *** <%= text%>
    </p>
    """
  end

  def display_message(%{uuid: uuid, text: text, username: username}) do
    ~E"""
      <p id="<%= uuid%>">
       <strong><%=username%>: </strong><%=text%>
     </p>
    """
  end
end 
