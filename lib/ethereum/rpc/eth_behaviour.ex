defmodule Ethereum.RPC.Eth.Behaviour do
  @moduledoc false

  @type error :: {:error, map() | binary() | atom()}

  # API methods
  @callback get_transaction_by_hash(binary()) :: {:ok, binary()} | error

end