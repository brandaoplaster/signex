ExUnit.start()

Mox.defmock(TeslaMock, for: Tesla.Adapter)

Application.put_env(:tesla, :adapter, TeslaMock)
