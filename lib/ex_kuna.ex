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

# не рабоатет
  def order_create() do
    side="buy"
    volume="1" #обьем в btc
    market="btcuah"
    price="1"

    url = "https://kuna.io/api/v2/orders"
    method = "POST"
    uri = "/api/v2/orders"
    preparams="access_key=#{@public_key}&market=#{market}&price=#{price}&side=#{side}&tonce=#{tonce()}&volume=#{volume}"
    signature=sign(uri, preparams, "POST")

    params=%{
             "access_key"=>@public_key,
             "market"=>market,
             "price"=>price,
             "side"=>side,
             "tonce"=>tonce(),
             "volume"=>volume,
             "signature"=>signature
           }
           #|> Poison.encode!

    headers=%{"Content-Type" => "application/json", "charset" => "utf-8"}
    #final_url="#{url}?#{params}&signature=#{signature}"
    case HTTPoison.post(url, params, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, body |> Poison.decode!}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  # не рабоатет
  def order_delete(id) do
    uri = "/api/v2/order/delete"
    url = @host <>uri
    method = "POST"
    preparams="access_key=#{@public_key}&id=#{id}&tonce=#{tonce()}"
    params=%{
    "access_key"=>@public_key,
    "id"=>id,
    "tonce"=>tonce()
    } |> Poison.encode!
    string="#{method}|#{uri}|#{preparams}"
    signature=hash(string,@secret_key)
    headers=%{"Content-Type" => "application/json", "charset" => "utf-8"}
    final_url="#{url}?#{preparams}&signature=#{signature}"
   HTTPoison.post(final_url,params,headers)

  end
  # не рабоатет
  def test_delete_order() do
    id = "2066671"
    uri = "/api/v2/order/delete"

    url = "https://kuna.io/api/v2/order/delete"
    preparams = "access_key=#{@public_key}&id=#{id}&tonce=#{tonce()}"
    params =
      %{
        "access_key" => @public_key,
        "id" => id,
        "tonce" => tonce(),
        "signature"=>sign(uri, preparams, "POST")
      } |> Poison.encode!

    headers = %{"Content-Type" => "application/json", "charset" => "utf-8"}
    final_url = url
    HTTPoison.post(final_url, params, headers)
  end


end
