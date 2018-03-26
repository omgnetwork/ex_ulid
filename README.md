# ExULID
Universally Unique Lexicographically Sortable Identifier (ULID) in Elixir.
Implemented according to [ulid/spec](https://github.com/ulid/spec).

## Why ULID?

UUID can be suboptimal for many uses-cases because:

- It isn't the most character efficient way of encoding 128 bits of randomness
- UUID v1/v2 is impractical in many environments, as it requires access to a unique, stable MAC address
- UUID v3/v5 requires a unique seed and produces randomly distributed IDs, which can cause fragmentation in many data structures
- UUID v4 provides no other information than randomness which can cause fragmentation in many data structures

Instead, herein is proposed ULID:

- 128-bit compatibility with UUID
- 1.21e+24 unique ULIDs per millisecond
- Lexicographically sortable!
- Canonically encoded as a 26 character string, as opposed to the 36 character UUID
- Uses Crockford's base32 for better efficiency and readability (5 bits per character)
- Case insensitive
- No special characters (URL safe)
- Monotonic sort order (correctly detects and handles the same millisecond)

## Installation

Add ExULID as a dependency in your project's `mix.exs`:

```
def deps do
  [
    {:ex_ulid, github: "omisego/ex_ulid"}
  ]
end
```

Then run `mix deps.get` to resolve and install it.

## Usage

Generate a ULID with the current time:

```ex
ExULID.ULID.generate()
#=> "01C9GJZZ3D530PE8Q0ZYV5HJ9K"
```

Generate a ULID for a specific time:

```ex
ExULID.ULID.generate_at(1469918176385)
#=> "01ARYZ6S41QJQECH4KPG6SEF3Y"
```

Decode the ULID back to get the timestamp and randomness:

```ex
ExULID.ULID.decode!("01ARYZ6S41QJQECH4KPG6SEF3Y")
#=> {1469918176385, "QJQECH4KPG6SEF3Y"}
```

## TODO
- [Monotonicity](https://github.com/ulid/spec#monotonicity) generator

# License

ExULID is released under the [Apache License](https://www.apache.org/licenses/LICENSE-2.0).
