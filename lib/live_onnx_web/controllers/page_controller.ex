defmodule LiveOnnxWeb.PageController do
  use LiveOnnxWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
