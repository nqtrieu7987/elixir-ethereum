defmodule Ethereum.Transport do
  @moduledoc """
  This defines a macro that handles the JSON-RPC HTTP send
  """
    @doc """
      Send macro used by RPC modules
    """
    defmacro __using__(_opts) do
      quote do

        # @doc """
          
        # Macro RPC send function

        # ## Example:
              
        #       case send("web3_clientVersion") do
        #         {:ok, version} -> {:ok, version}
        #         {:error, reason} -> {:error, reason}
        #       end

        # """
        @doc false
        @spec send(method :: String.t, params :: map) :: {:ok, map} | {:error, String.t}
        def send(method, params \\ %{}, decode \\ true) do
          require Logger
          require IEx
          enc = %{
            "method": method, 
            "params": params, 
            "id": 0
            }
            |> Poison.encode!

          ethereum_host = case System.get_env("ETHEREUM_HOST") do
            nil ->
              # Logger.error "ETHEREUM_HOST ENVIRONMENT VARIABLE NOT SET. Using 127.0.0.1"
              "127.0.0.1"
            url ->
              # Logger.info "ETHEREUM_HOST ENVIRONMENT VARIABLE SET. Using #{url}"
              url
          end

          ethereum_port = case System.get_env("ETHEREUM_PORT") do
            nil ->
              # Logger.error "ETHEREUM_PORT ENVIRONMENT VARIABLE NOT SET. Using 8501"
              "8545"
            port ->
              # Logger.info "ETHEREUM_PORT ENVIRONMENT VARIABLE SET. Using #{port}"
              port
          end

          # Requires --rpcvhosts=* on Eth Daemon - TODO: Clean up move PORT to run script
          daemon_host = "http://" <> ethereum_host <> ":" <> ethereum_port
          
          resp = HTTPoison.post!(daemon_host, enc, [{"Content-Type", "application/json"}],[timeout: 350_000, recv_timeout: 350_000])

          case Poison.decode(resp.body) do
            {:ok, body} ->
              case decode do
                true -> {:ok, unhex(body["result"])}
                false -> {:ok, body["result"]}
              end
            _ ->
              {:error, "bad_response"}
          end
        end
  
        # @doc """
        # Transport macro function to strip Ethereum 0x for easier decoding later.

        # ## Example:
              
        #     iex> __MODULE__.unhex("0x557473f9c6029a2d4b7ac8a37aa407414db6820faf1f7fa48b3b038f857d5aac")
        #     "557473f9c6029a2d4b7ac8a37aa407414db6820faf1f7fa48b3b038f857d5aac"
        # """
        @doc false
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
  