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

    
          api_key = case System.get_env("ETHEREUM_API_KEY") do
            nil ->
              # Logger.error "ETHEREUM_API_KEY ENVIRONMENT VARIABLE NOT SET. Using 0x"
              "0x"
            k ->
              # Logger.info "ETHEREUM_API_KEY ENVIRONMENT VARIABLE SET. Using #{k}"
              k
          end

          api_secret = case System.get_env("ETHEREUM_API_SECRET") do
            nil ->
              # Logger.error "ETHEREUM_API_SECRET ENVIRONMENT VARIABLE NOT SET. Using 0x"
              "0x"
            s ->
              # Logger.info "ETHEREUM_API_SECRET ENVIRONMENT VARIABLE SET. Using #{s}"
              s
          end

          timeout = case System.get_env("ETHEREUM_API_TIMEOUT") do
            nil ->
              # Logger.error "ETHEREUM_API_TIMEOUT ENVIRONMENT VARIABLE NOT SET. Using 350_000"
              350_000
            t ->
              # Logger.info "ETHEREUM_API_TIMEOUT ENVIRONMENT VARIABLE SET. Using #{t}"
              t
          end

          recv_timeout = case System.get_env("ETHEREUM_API_RECV_TIMEOUT") do
            nil ->
              # Logger.error "ETHEREUM_API_RECV_TIMEOUT ENVIRONMENT VARIABLE NOT SET. Using 350_000"
              350_000
            t ->
              # Logger.info "ETHEREUM_API_RECV_TIMEOUT ENVIRONMENT VARIABLE SET. Using #{t}"
              t
          end

          # Requires --rpcvhosts=* on Eth Daemon - TODO: Clean up move PORT to run script
          daemon_host = case System.get_env("ETHEREUM_USE_SSL") do
            "true" -> "https://" <> ethereum_host <> ":" <> ethereum_port
            _ -> "http://" <> ethereum_host <> ":" <> ethereum_port
          end
          
          resp = 
            HTTPoison.post!(daemon_host, enc, [
              {"Content-Type", "application/json"},
              {"Api-Key", api_key},
              {"Api-Secret", api_secret}
            ],
            [timeout: timeout, recv_timeout: recv_timeout, hackney: [:insecure]])

          case Poison.decode(resp.body) do
            {:ok, body} ->
              case decode do
                true -> 
                  # Logger.warn "resp.body // decode true: #{inspect body}"
                  {:ok, unhex(body["result"])}
                false -> 
                  # Logger.warn "resp.body // decode false: #{inspect body}"
                  {:ok, body["result"]}
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
  