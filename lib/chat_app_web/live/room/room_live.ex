defmodule ChatAppWeb.RoomLive do
  use ChatAppWeb, :live_view


  @impl true
  def mount(%{"id" => room_id}, _session, socket) do
   {:ok, assign(socket, room_id: room_id)}
  end
end
