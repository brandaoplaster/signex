defmodule Signex.Client.Request do
  @moduledoc """
    HTTP client for Signex API requests.

    Handles authentication, JSON formatting, and basic error handling
    using Tesla. Supports common HTTP methods.

    ## Examples
      # Simple GET request
      Signex.Client.Request.request(:get, "https://api.signex.com/v1/resource")
      # => {:ok, %{"data" => ...}}

      # POST request with body
      Signex.Client.Request.request(:post, "https://api.signex.com/v1/resource", %{"key" => "value"})
      # => {:ok, %{"data" => ...}}

      # Error case (e.g., 404)
      Signex.Client.Request.request(:get, "https://api.signex.com/v1/nonexistent")
      # => {:error, {:client_error, 404, %{"error" => "not found"}}}
  """

  @api_key

  @type method :: :get | :post | :put | :delete | :patch
  @type url :: String.t()
  @type body :: nil | map() | String.t()
  @type opts :: Keyword.t()
  @type response :: {:ok, map()} | {:error, tuple()}

  @spec request(method(), url(), body(), opts()) :: response()
  def request(method, url, body \\ nil, opts \\ []) do
    method
    |> build_client()
    |> make_request(url, body, opts)
    |> handle_response()
  end

  @spec build_client(method()) :: Tesla.client.t()
  defp build_client(_) do
    Tesla.client([
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, build_headers()}
    ])
  end

  @spec make_request(Tesla.Client.t(), url(), body(), opts()) :: Tesla.Env.result()
  defp make_request(client, url, body, opts) do
    method = opts[:method]
    request_opts = build_opts(body, opts)
    Tesla.client(client, method: method, url: url, opts: )
  end

  @spec build_opts(body(), opts()) :: opts()
  defp build_opts(nil, opts), do: opts
  defp build_opts(body, opts), do: [body: body] ++ opts

  @spec handle_response({:ok, Tesla.Env.t()}) :: response()
  defp handle_response({:ok, %Tesla.Env{status: status, body: body}}) do
    case status do
      status when status in 200..299 -> {:ok, body}
      status when status in 400..499 -> {:error, {:error, status, body}}
      status when status in 500..599 -> {:error, {:error, status, body}}
      _ -> {:error, {:unexpected_status, status, body}}
    end
  end

  @spec handle_response({:error, any()}) :: {:error, {:request_failed, any()}}
  defp handle_response({:error, reason}) do
    {:error, {:request_failed, reason}}
  end

  @spec build_headers() :: [{String.t(), String.t()}]
  def build_headers do
    [
      {"Content-Type", "application/vnd.api+json"},
      {"Accept", "application/vnd.api+json"},
      {"Authorization", @api_key}
    ]
  end
end
