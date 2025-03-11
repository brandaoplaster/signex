defmodule Signex.Client.HttpClient do
  @moduledoc """
    Provides HTTP client functionality for Signex API integration.

    This module allows other modules to easily incorporate HTTP client capabilities
    by using the `use Signex.Client.HttpClient` macro with an endpoint configuration.

    When a module uses this client, it automatically implements the `Signex.Client.HttpBehaviour`
    and gains access to standard HTTP methods (GET, POST, PATCH, DELETE) configured
    to work with the specified endpoint.

    ## Example
        defmodule Signex.Endpoints.Users do
          use Signex.Client.HttpClient, endpoint: "/users"
        end

        # Then you can use:
        Signex.Endpoints.Users.get()
        Signex.Endpoints.Document.post(%{name: "Contract"})
  """

  defmacro __using__(opts) do
    quote do
      @behaviour Signex.Client.HttpBehaviour

      @endpoint Keyword.fetch!(unquote(opts), :endpoint)

      def post(body, opts \\ []) do
        url = "#{@endpoint}"
        IO.puts("POST #{url} with #{inspect(body)}, opts: #{inspect(opts)}")
      end

      def get(opts \\ []) do
        url = "#{@endpoint}"
        IO.puts("GET #{url}, opts: #{inspect(opts)}")
      end

      def patch(body, opts \\ []) do
        url = "#{@endpoint}"
        IO.puts("PATCH #{url} with #{inspect(body)}, opts: #{inspect(opts)}")
      end

      def delete(opts \\ []) do
        url = "#{@endpoint}"
        IO.puts("DELETE #{url}, opts: #{inspect(opts)}")
      end
    end
  end
end
