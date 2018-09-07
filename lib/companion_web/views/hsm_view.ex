defmodule CompanionWeb.HSMView do
  use CompanionWeb, :view

  def render("create.json", %{response: response}) do
    response
  end

  def render("error.json", %{reason: reason}) do
    %{error: reason}
  end
end
