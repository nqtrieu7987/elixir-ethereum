defmodule Exthereum.Conversion do
  @moduledoc """
  Various Wei/Eth Unit Conversion Functions
  """
alias Exthereum.Units
  @units %Units{}

  @spec wei_to_eth(integer) :: float
  def wei_to_eth(wei) do
    wei / @units.eth
  end

  @spec to_wei(amount :: integer, denomination :: atom) :: integer
  def to_wei(amount, denomination) do
    case denomination do
      :ether ->
        @units.eth / amount
      _ ->
        0
    end

  end
end
