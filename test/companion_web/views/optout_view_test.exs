defmodule CompanionWeb.OptOutViewTest do
  use CompanionWeb.ConnCase, async: true

  test "format_timestamp correct" do
    assert CompanionWeb.OptOutView.format_timestamp(Timex.now()) == "now"
  end
end
