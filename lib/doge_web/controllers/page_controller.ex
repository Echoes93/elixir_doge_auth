defmodule DogeWeb.PageController do
  use DogeWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
