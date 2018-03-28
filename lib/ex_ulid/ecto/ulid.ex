defmodule ExULID.Ecto.ULID do
  @moduledoc """
  An Ecto type for UUIDs strings.
  """
  @behaviour Ecto.Type
  alias ExULID.ULID, as: Generator

  @doc """
  The Ecto type.
  """
  @spec type() :: atom
  def type, do: :binary_id

  @doc """
  Casts the given input to binary ULID.

  This function is called on external input and can return any type,
  as long as the `dump/1` function is able to convert the returned
  value back into an Ecto native type. There are two situations where
  this function is called:

    1. When casting values by `Ecto.Changeset`
    2. When passing arguments to `Ecto.Query`
  """
  @spec cast(any) :: {:ok, String.t} | :error
  def cast(string) when byte_size(string) == 26 do
    # TODO: Check that the string has valid decoded value
    {:ok, :binary.bin_to_list(string)}
  end
  def cast(binary) when byte_size(binary) == 24 do
    # TODO: Check that the binary has valid value, then convert to string
    {:ok, binary}
  end
  def cast(_), do: :error

  @doc """
  Converts the binary ULID retrieved from database to a string ULID.

  This function is called when loading data from the database and
  receive an Ecto native type. It can return any type, as long as
  the `dump/1` function is able to convert the returned value back
  into an Ecto native type.
  """
  @spec load(<<_::128>>) :: {:ok, String.t}
  def load(<<_::128>> = binary_ulid), do: Generator.encode(binary_ulid)

  @doc """
  Converts the data into an Ecto native type (i.e. :binary_id).

  This function is called with any term that was stored in the struct
  and it needs to validate them and convert it to an Ecto native type.
  """
  @spec dump(any) :: {:ok, binary} | {:error, String.t}
  def dump(string) when byte_size(string) == 26 do
    # TODO: The string at this point shoudl already be valid. Just need to convert it to binary
    {:ok, :binary.bin_to_list(string)}
  end
  def dump(_), do: {:error, "ULID must be exactly 26 characters"}

  # Callback invoked by autogenerate fields.
  @doc false
  @spec autogenerate() :: {:ok, String.t}
  def autogenerate, do: Generator.generate()
end
