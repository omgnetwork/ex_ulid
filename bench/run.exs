Benchee.run(%{
  "encode" => &ExULID.ULID.generate/0
})

Benchee.run(%{
  "decode" => fn() -> ExULID.ULID.decode("01ARYZ6S41QJQECH4KPG6SEF3Y") end
})
