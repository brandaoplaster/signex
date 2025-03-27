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

  @api_key Application.compile_env(:signex, :api_key) || System.get_env("SIGNEX_API_KEY")

  @type method :: :get | :post | :put | :delete | :patch
  @type url :: String.t()
  @type body :: nil | map() | String.t()
  @type opts :: Keyword.t()
  @type response ::
          {:ok, map()}
          | {:error,
             {:client_error | :server_error | :unexpected_status | :request_failed, any()}}

  @client_error_range 400..499
  @server_error_range 500..599
  @success_range 200..299

  @doc """
  Makes an HTTP request to the specified URL with the given method, body, and options.

  Returns `{:ok, response_body}` for successful requests, or
  `{:error, {error_type, status_code, response_body}}` for errors.
  """
  @spec request(method(), url(), body(), opts()) :: response()
  def request(method, url, body \\ nil, opts \\ []) do
    client = build_client()

    {method, url, body, opts}
    |> execute_request(client)
    |> handle_response()
  end

  @spec execute_request({method(), url(), body(), opts()}, Tesla.Client.t()) :: Tesla.Env.result()
  defp execute_request({method, url, body, opts}, client) do
    request_opts = build_request_opts(body, opts)

    case method do
      :get -> Tesla.get(client, url, request_opts)
      :post -> Tesla.post(client, url, body, request_opts)
      :put -> Tesla.put(client, url, body, request_opts)
      :delete -> Tesla.delete(client, url, request_opts)
      :patch -> Tesla.patch(client, url, body, request_opts)
    end
  end

  @spec build_client() :: Tesla.Client.t()
  defp build_client do
    middleware = [
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, build_headers()},
      {Tesla.Middleware.Retry, delay: 500, max_retries: 3},
      {Tesla.Middleware.Timeout, timeout: 30_000}
    ]

    Tesla.client(middleware)
  end

  @spec build_request_opts(body(), opts()) :: opts()
  defp build_request_opts(nil, opts), do: opts
  defp build_request_opts(_body, opts), do: opts

  @spec handle_response({:ok, Tesla.Env.t()} | {:error, any()}) :: response()
  defp handle_response({:ok, %Tesla.Env{status: status, body: body}}) do
    cond do
      status in @success_range -> {:ok, body}
      status in @client_error_range -> {:error, {:client_error, status, body}}
      status in @server_error_range -> {:error, {:server_error, status, body}}
      true -> {:error, {:unexpected_status, status, body}}
    end
  end

  defp handle_response({:error, reason}) do
    {:error, {:request_failed, reason}}
  end

  @spec build_headers() :: [{String.t(), String.t()}]
  defp build_headers do
    [
      {"Content-Type", "application/vnd.api+json"},
      {"Accept", "application/vnd.api+json"},
      {"Authorization", "Bearer #{@api_key}"}
    ]
  end
end
