defmodule Signex.Client.Request do
    @moduledoc """
    Provides HTTP client functionality for Signex API integration.
  """

  @api_key

  def request(method, url, body \\ nil, opts \\ []) do
    method
    |> build_client()
    |> make_request(url, body, opts)
    |> handle_response()
  end

  defp build_client(_) do
    Tesla.client([
      Tesla.Middleware.JSON,
      {Tesla.Middleware.Headers, build_headers()}
    ])
  end

  defp make_request(client, url, body, opts) do
    method = opts[:method]
    request_opts = build_opts(body, opts)
    Tesla.client(client, method: method, url: url, opts: )
  end

  defp build_opts(nil, opts), do: opts
  defp build_opts(body, opts), do: [body: body] ++ opts

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}}) do
    case status do
      status when status in 200..299 -> {:ok, body}
      status when status in 400..499 -> {:error, {:error, status, body}}
      status when status in 500..599 -> {:error, {:error, status, body}}
      _ -> {:error, {:unexpected_status, status, body}}
    end
  end

  defp handle_response({:error, reason}) do
    {:error, {:request_failed, reason}}
  end

  defp handle_response({:ok, %Tesla.Env{status: status, body: body}}) do
    {:ok, body}
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
