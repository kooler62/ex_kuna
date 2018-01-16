defmodule ExKuna do
  @moduledoc """
  Documentation for KunaEx.
  """

  @doc """
  https://github.com/mfiyalka/kuna/blob/master/src/API/Kuna/ApiKuna.php
  """
  @host "https://kuna.io/api/v2"
  @kuna "https://kuna.io"
  @public_key "HC85Tcs2E926Dxu2PgFex6JKESmxZ5ymYDCm7fAx"
  @secret_key "n7GkZpAnd0EQc5xERRJRqxgIx1xmqp9ONqxxkX12"
  @headers %{"Content-Type" => "application/json", "charset" => "utf-8"}

  def timestamp, do: get_request("#{@host}/timestamp")

  def tickers(market \\ "btcuah"), do: get_request("#{@host}/tickers/#{market}")

  def order_book(market \\ "btcuah"), do: get_request("#{@host}/order_book?market=#{market}")

  def history(market \\ "btcuah"), do: get_request("#{@host}/trades?market=#{market}")


  def get_request(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body |> Poison.decode!}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def post_request(url) do
    HTTPoison.post(url, [], @headers)
  end

  def tonce(), do: "#{System.system_time(:second)}000"

  def hash(string, key) do
    :crypto.hmac(:sha256, key, string) |> Base.encode16 |> String.downcase
  end

  def sign(uri, params, method \\ "GET") do
    string = "#{method}|#{uri}|#{params}"
    :crypto.hmac(:sha256, @secret_key, string) |> Base.encode16 |> String.downcase
  end
  ############# USERS METHODS #############

  def user_info() do
    uri = "/api/v2/members/me"
    params = "access_key=#{@public_key}&tonce=#{tonce()}"
    url = "#{@kuna}#{uri}?#{params}&signature=#{sign(uri, params)}"
    get_request(url)
  end

  def orders(market \\ "btcuah") do
    uri = "/api/v2/orders"
    params = "access_key=#{@public_key}&market=#{market}&tonce=#{tonce()}"
    url = "#{@kuna}#{uri}?#{params}&signature=#{sign(uri, params)}"
    get_request(url)
  end

  def orders_history(market \\ "btcuah") do
    uri = "/api/v2/trades/my"
    params = "access_key=#{@public_key}&market=#{market}&tonce=#{tonce()}"
    url = "#{@kuna}#{uri}?#{params}&signature=#{sign(uri, params)}"
    get_request(url)
  end

  # volume in btc
  def order_create(side, volume, price, market \\ "btcuah") do
    uri = "/api/v2/orders"
    params="access_key=#{@public_key}&market=#{market}&price=#{price}&side=#{side}&tonce=#{tonce()}&volume=#{volume}"
    url = "#{@kuna}#{uri}?#{params}&signature=#{sign(uri, params, "POST")}"
    post_request(url)

  end

  # volume in btc
  def order_create_test() do
    side = "buy"
    volume = "1"
    market = "btcuah"
    price = "1"

    uri = "/api/v2/orders"
    params="access_key=#{@public_key}&market=#{market}&price=#{price}&side=#{side}&tonce=#{tonce()}&volume=#{volume}"
    url = "#{@kuna}#{uri}?#{params}&signature=#{sign(uri, params, "POST")}"
    post_request(url)

  end

  def order_delete(id) do
    uri = "/api/v2/order/delete"
    params = "access_key=#{@public_key}&id=#{id}&tonce=#{tonce()}"
    url = "#{@kuna}#{uri}?#{params}&signature=#{sign(uri, params, "POST")}"
    post_request(url)
  end


end
