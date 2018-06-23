defmodule ExULID.Ecto.ULID do
  @moduledoc """
  An Ecto type for UUIDs strings.

  # Example

  First, add a new migration to add the new field with the `binary_id` type:

      defmodule MyRepo.Migrations.CreateSomeTable do
        use Ecto.Migration

        def change do
          create table("some_tables") do
            add :the_ulid_field, :binary_id
          end
        end
      end

  Then add the new field to the schema:

      defmodule SomeSchema do
        use Ecto.Schema

        schema "some_tables" do
          field :the_ulid_field, ExULID.Ecto.ULID
        end
      end
  """
  @behaviour Ecto.Type
  alias ExULID.ULID

  @doc """
  The Ecto type.
  """
  @spec type() :: atom
  def type, do: :binary_id

  @doc """
  Casts the given input to a string ULID.

  Even if the input is already binary ULID, it casts back to a string.
  This is so that the casted value can always be retrieved in its human-readable format.
  """
  @spec cast(String.t | <<_::128>>) :: {:ok, String.t} | {:error, String.t}
  def cast(string_uuid) when is_binary(string_uuid) and byte_size(string_uuid) == 26 do
    {:ok, string_uuid}
  end
  def cast(<<_::128>> = binary_uuid) do
    ULID.encode(binary_uuid)
  end
  def cast(_), do: :error

  @doc """
  Converts the binary ULID retrieved from database to a string ULID.
  """
  @spec load(<<_::128>>) :: {:ok, String.t}
  def load(<<_::128>> = binary_ulid) do
    ULID.encode(binary_ulid)
  end
  def load(_), do: :error

  @doc """
  Converts the data into an Ecto native type (i.e. :binary_id),
  ready to be stored.

  This function does not validate the content of the ULID as it should have
  been validated since `cast/1`.
  """
  @spec dump(any) :: {:ok, binary} | {:error, String.t}
  def dump(string) when is_binary(string) and byte_size(string) == 26 do
    ULID.to_binary(string)
  end
  def dump(_), do: :error

  @doc """
  Generates a string ULID.
  """
  @spec generate() :: {:ok, String.t}
  def generate do
    {:ok, ulid} = ULID.generate()
    ulid
  end

  # Callback invoked by autogenerate fields.
  @doc false
  def autogenerate, do: generate()
end
