defmodule KunaExTest do
  use ExUnit.Case
  doctest KunaEx

  test "greets the world" do
    assert KunaEx.hello() == :world
  end
end
