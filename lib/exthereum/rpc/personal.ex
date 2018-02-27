defmodule Exthereum.Personal do
@moduledoc """
Personal namespace for Ethereum JSON-RPC
This could be considered dangerous as it requires the admin api to be exposed over JSON-RPC. Use only in a safe environment and see README to enable this namespace in Geth.
"""
  use Exthereum.Transport
  alias Exthereum.Conversion
  require Logger
  
  @spec new_account(password :: String.t, password_confirmation :: String.t) :: {:ok, String.t} | {:error, String.t}
  def new_account(password, password_confirmation) do
    case __MODULE__.send("personal_newAccount",[password]) do
      {:ok, account_hash} ->
        {:ok, account_hash}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec unlock_account(account :: String.t, password :: String.t) :: {:ok, boolean} | {:error, String.t}
  def unlock_account(account, password) do
    case __MODULE__.send("personal_unlockAccount", [account, password]) do
      {:ok, result} ->
        {:ok, result}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec lock_account(account :: String.t) :: {:ok, boolean} | {:error, String.t}
  def lock_account(account) do
    case __MODULE__.send("personal_lockAccount", [account]) do
      {:ok, result} ->
        {:ok, result}
      {:error, reason} ->
        {:error, reason}
    end
  end

  @spec send_transaction(from :: String.t, to :: String, value :: float, password :: String.t) :: {:ok, boolean} | {:error, String.t}
  def send_transaction(from, to, value, password) do
    wei_value = Conversion.to_wei(value, :ether)
    hex_wei_value = "0x" <> Hexate.encode(value)
    Logger.warn "weit value to send: " <> hex_wei_value
    params = [%{
      "from": from,
      "to": to,
      "gas": "0x76c0", # 30400,
      #"gasPrice": "0x9184e72a000", # 10000000000000
      "value": hex_wei_value,
      "data": "0x0"}, password]

    case __MODULE__.send("personal_sendTransaction", params) do
      {:ok, result} ->
        {:ok, result}
      {:error, reason} ->
        {:error, reason}
    end
  end

end
