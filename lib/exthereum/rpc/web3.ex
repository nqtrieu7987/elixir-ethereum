defmodule Exthereum.Web3 do
  @moduledoc """
  Web3 Namespace for Ethereum JSON-RPC
  """

  use Exthereum.Transport

  @spec client_version :: {:ok, String.t} | {:error, String.t}
  def client_version do
    case send("web3_clientVersion") do
      {:ok, version} ->
        {:ok, version}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec sha3(String.t) :: {:ok, float} | {:error, String.t}
  def sha3(str) do
    case __MODULE__.send("web3_sha3",[str]) do
      {:ok, sha} ->
        {:ok, sha}
      {:error, reason} ->
        {:error, reason}
    end

  end

end
