# Exthereum
# Use Elixir to control all the Ethereum Things
This library exists to present a convenient interface to control a full Ethereum node from Elixir, abstracting away the need to deal with the JSON-RPC API directly. It decodes the hex responses when necessary and functions return the idiomatic {:ok, data} | {:error, reason} tuples whenever possible. The goal is to cover the entire JSON-RPC API for Geth/Parity. This project has @specs for every function and is using Dialyzer + ExUnit.

So far I have "cherry picked" the most commonly used functions from https://github.com/ethereum/wiki/wiki/JSON-RPC. I plan to fill in the blanks. Pull requests welcomed. Because the goal is to fully manage an Ethereum node from Elixir, I have included some of the more commonly used Admin and Personal API functions which will require geth to be started with `--rpcapi "db,eth,net,web3,personal"`. This should only be done in a safe network environment if at all.

UPDATE: Currently you can create accounts, unlock accounts, lock accounts, query balances, and send eth to anyone on the blockchain.

```elixir
mix test
mix dialyzer
```
### Currently Implemented Geth JSON-RPC methods
```elixir
      iex> Exthereum.client_version
      {:ok, "Geth/v1.6.5-stable-cf87713d/darwin-amd64/go1.8.3"}

      iex> Exthereum.sha3("0x68656c6c6f20776f726c64")
      {:ok, "47173285a8d7341e5e972fc677286384f802f8ef42a5ec5f03bbfa254cb01fad"}

      iex> Exthereum.net_version
      {:ok, "1"}

      iex> Exthereum.peer_count
      {:ok, "19"}

      iex> Exthereum.listening
      {:ok, true}

      iex> Exthereum.protocol_version
      {:ok, 63}

      iex> Exthereum.syncing
      {:ok, false}

      iex> Exthereum.coinbase
      {:ok, "78fc2b9b6cf9b18f91037a5e0e074a479be9dca1"}

      iex> Exthereum.mining
      {:ok, true}

      iex> Exthereum.hashrate
      {:ok, "0"}

      iex> Exthereum.gas_price
      {:ok, 22061831512}

      iex> Exthereum.accounts
      {:ok, ["0x78fc2b9b6cf9b18f91037a5e0e074a479be9dca1",
        "0x141feb71895530f537c847d62f039d9be895bd35",
        "0xe55c5bb9d42307e03fb4aa39ccb878c16f6f901e",
        "0x50172f916cb2e64172919090af4ff0ba4638d8dd"]}

      iex> Exthereum.block_number
      {:ok, 3858216}

      iex> Exthereum.get_balance("0xfE8bf4ca8A6170E759E89EDB5cc9adec3e33493f") # Donations accepted :-)
      {:ok, 0.4650075166583676}

      iex> Exthereum.transaction_count("0xfE8bf4ca8A6170E759E89EDB5cc9adec3e33493f")
      {:ok, 3858216}

      iex> Exthereum.new_account("h4ck3r", "h4ck3r")
      {:ok, "50172f916cb2e64172919090af4ff0ba4638d8dd"}

      iex> Exthereum.unlock_account("0xe55c5bb9d42307e03fb4aa39ccb878c16f6f901e", "h4ck3r")
      {:ok, true}

      iex> Exthereum.lock_account("0xe55c5bb9d42307e03fb4aa39ccb878c16f6f901e")
      {:ok, true}

      iex>  Exthereum.send_transaction("0xe55c5bb9d42307e03fb4aa39ccb878c16f6f901e", "0xfE8bf4ca8A6170E759E89EDB5cc9adec3e33493f", 0.00043, "h4ck3r")
      {:ok, "88c646f79ecb2b596f6e51f7d5db2abd67c79ff1f554e9c6cd2915f486f34dcb"}
```

## Installation
## hex.pm
```elixir
If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `exthereum` to your list of dependencies in `mix.exs`:
def deps do
  [{:exthereum, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/exthereum](https://hexdocs.pm/exthereum).
# elixir-ethereum
