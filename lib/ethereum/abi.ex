defmodule Ethereum.ABI do
  
  @spec load_abi(binary()) :: list() | {:error, atom()}
  @doc "Loads the abi at the file path and reformats it to a map"
  def load_abi(file_path) do
    file = File.read(Path.join(System.cwd(), file_path))

    case file do
      {:ok, abi} -> __MODULE__.reformat_abi(Poison.Parser.parse!(abi, %{}))
      err -> err
    end
  end

  @spec reformat_abi(list()) :: map()
  @doc "Reformats abi from list to map with event and function names as keys"
  def reformat_abi(abi) do
    abi
    |> Enum.map(&map_abi/1)
    |> Map.new()
  end

  @spec encode_event(binary()) :: binary()
  @doc "Encodes event based on signature"
  def encode_event(signature) do
    :keccakf1600.sha3_256(signature) |> Base.encode16(case: :lower)
  end

  @spec encode_data(binary(), list()) :: binary()
  @doc "Encodes data into Ethereum hex string based on types signature"
  def encode_data(types_signature, data) do
    ABI.TypeEncoder.encode_raw(
      [List.to_tuple(data)],
      ABI.FunctionSelector.decode_raw(types_signature)
    )
  end

  @spec encode_options(map(), list()) :: map()
  @doc "Encodes list of options and returns them as a map"
  def encode_options(options, keys) do
    keys
    |> Enum.filter(fn option ->
      Map.has_key?(options, option)
    end)
    |> Enum.map(fn option ->
      {option, encode_option(options[option])}
    end)
    |> Enum.into(%{})
  end

  @spec encode_option(integer()) :: binary()
  @doc "Encodes options into Ethereum JSON RPC hex string"
  def encode_option(0), do: "0x0"

  def encode_option(nil), do: nil

  def encode_option(value) do
    "0x" <>
      (value
       |> :binary.encode_unsigned()
       |> Base.encode16(case: :lower)
       |> String.trim_leading("0"))
  end
  
  @spec encode_method_call(map(), binary(), list()) :: binary()
  @doc "Encodes data and appends it to the encoded method id"
  def encode_method_call(abi, name, input) do
    encoded_method_call =
      method_signature(abi, name) <> encode_data(types_signature(abi, name), input)

    encoded_method_call |> Base.encode16(case: :lower)
  end

  @spec method_signature(map(), binary()) :: binary()
  @doc "Returns the 4 character method id based on the hash of the method signature"
  def method_signature(abi, name) do
    if abi[name] do
      input_signature = "#{name}#{types_signature(abi, name)}" |> :keccakf1600.sha3_256()

      # Take first four bytes
      <<init::binary-size(4), _rest::binary>> = input_signature
      init
    else
      raise "#{name} method not found in the given abi"
    end
  end

  @spec types_signature(map(), binary()) :: binary()
  @doc "Returns the type signature of a given function"
  def types_signature(abi, name) do
    input_types = Enum.map(abi[name]["inputs"], fn x -> x["type"] end)
    types_signature = Enum.join(["(", Enum.join(input_types, ","), ")"])
    types_signature
  end
  
  # ABI mapper
  defp map_abi(x) do
    case {x["name"], x["type"]} do
      {nil, "constructor"} -> {:constructor, x}
      {nil, "fallback"} -> {:fallback, x}
      {name, _} -> {name, x}
    end
  end

  @spec decode_data(binary(), binary()) :: any()
  @doc "Decodes data based on given type signature"
  def decode_data(types_signature, data) do
    {:ok, trim_data} = String.slice(data, 2..String.length(data)) |> Base.decode16(case: :lower)

    ABI.decode(types_signature, trim_data) |> List.first()
  end

  @spec decode_output(map(), binary(), binary()) :: list()
  @doc "Decodes output based on specified functions return signature"
  def decode_output(abi, name, output) do
    {:ok, trim_output} =
      String.slice(output, 2..String.length(output)) |> Base.decode16(case: :lower)

    output_types = Enum.map(abi[name]["outputs"], fn x -> x["type"] end)
    types_signature = Enum.join(["(", Enum.join(output_types, ","), ")"])
    output_signature = "#{name}(#{types_signature})"

    outputs =
      ABI.decode(output_signature, trim_output)
      |> List.first()
      |> Tuple.to_list()

    outputs
  end

  @spec keys_to_decimal(map(), list()) :: map()
  def keys_to_decimal(map, keys) do
    for k <- keys, into: %{}, do: {k, map |> Map.get(k) |> Ethereum.hex_to_decimal()}
  end

end