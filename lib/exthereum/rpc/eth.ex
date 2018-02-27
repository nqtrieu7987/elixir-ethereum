defmodule Exthereum.Eth do
  @moduledoc """
  Eth Namespace for Ethereum JSON-RPC
  """
  use Exthereum.Transport
  alias Exthereum.Conversion

  @eth_server_url Application.get_env(:exthereum, :eth_server_url)


  @spec get_balance(String.t) :: {:ok, float} | {:error, String.t}
  def get_balance(account_hash) do
    case __MODULE__.send("eth_getBalance",[account_hash, "latest"]) do
      {:ok, wei_val} ->
        ether_val = wei_val
        |> Hexate.to_integer
        |> Conversion.wei_to_eth
        {:ok, ether_val}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec protocol_version :: {:ok, integer} | {:error, String.t}
  def protocol_version do
    case __MODULE__.send("eth_protocolVersion",[]) do
      {:ok, version} ->
        decoded_version = version
          |> Hexate.to_integer
        {:ok, decoded_version}
      {:error, reason} ->
        {:error, reason}
    end
  end

  """
  possibly change this to return:
  {:ok, true, data} | {:ok, false, %{}}
  """
  @spec syncing :: {:ok, map} | {:error, String.t}
  def syncing do
    case send("eth_syncing") do
      {:ok, result} ->
        {:ok, result}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec coinbase :: {:ok, String.t} | {:error, String.t}
  def coinbase do
    case __MODULE__.send("eth_coinbase",[]) do
      {:ok, hash} ->
        {:ok, hash}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec mining :: {:ok, boolean} | {:error, String.t}
  def mining do
    case send("eth_mining") do
      {:ok, result} ->
        {:ok, result}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec hashrate :: {:ok, String.t} | {:error, String.t}
  def hashrate do
    case send("eth_hashrate") do
      {:ok, result} ->
        {:ok, result}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec gas_price :: {:ok, String.t} | {:error, String.t}
  def gas_price do
    case send("eth_gasPrice") do
      {:ok, result} ->
        price = result
          |> Hexate.to_integer
        {:ok, price}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec accounts :: {:ok, list} | {:error, String.t}
  def accounts do
    case send("eth_accounts") do
      {:ok, result} ->
        {:ok, result}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec block_number :: {:ok, integer} | {:error, String.t}
  def block_number do
    case __MODULE__.send("eth_blockNumber",[]) do
      {:ok, block} ->
        decoded_number = block
          |> Hexate.to_integer
        {:ok, decoded_number}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec transaction_count(account_hash :: String.t) :: {:ok, integer} | {:error, String.t}
  def transaction_count(account_hash) do
    case __MODULE__.send("eth_getTransactionCount",[account_hash, "latest"]) do
      {:ok, block} ->
        decoded_number = block
          |> Hexate.to_integer
        {:ok, decoded_number}
      {:error, reason} ->
        {:error, reason}
    end
  end


end
