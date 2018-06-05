defmodule ExKunaTest do
  use ExUnit.Case
  doctest ExKuna

  test "greets the world" do
    assert ExKuna.hello() == :world
  end
end
