defmodule Exthereum.Net do
  @moduledoc """
  Net Namespace for Ethereum JSON-RPC
  """
  use Exthereum.Transport

  @eth_server_url Application.get_env(:exthereum, :eth_server_url)

  @spec version :: {:ok, float} | {:error, String.t}
  def version do
    case __MODULE__.send("net_version",[]) do
      {:ok, version} ->
        {:ok, version}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec peer_count :: {:ok, integer} | {:error, String.t}
  def peer_count do
    case __MODULE__.send("net_peerCount",[]) do
      {:ok, count} ->
        count
        |> Hexate.to_integer
        {:ok, count}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec listening :: {:ok, boolean} | {:error, String.t}
  def listening do
    case __MODULE__.send("net_listening",[]) do
      {:ok, response} ->
        {:ok, response}
      {:error, reason} ->
        {:error, reason}
    end
  end

end
