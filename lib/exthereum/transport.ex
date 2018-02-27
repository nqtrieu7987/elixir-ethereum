defmodule Exthereum.Transport do
@moduledoc """
This defines a macro that handles the JSON-RPC HTTP send
"""
  @doc"""
  send macro used by RPC modules
  """
  defmacro __using__(_opts) do
    quote do
      @spec send(method :: String.t, params :: map) :: {:ok, map} | {:error, String.t}
      def send(method, params \\ %{}) do
        require Logger
        enc = %{"method": method, "params": params, "id": 0}
          |> Poison.encode!
        resp = HTTPoison.post!(Application.get_env(:exthereum, :eth_server_url), enc)
        case Poison.decode(resp.body) do
          {:ok, body} ->
            IO.inspect body
            {:ok, unhex(body["result"])}
          _ ->
            {:error, "bad_response"}
        end
      end

      @spec unhex(String.t) :: String.t
      def unhex("0x"<>str) do
        str
      end
      def unhex(str) do
        str
      end

    end

  end

end
