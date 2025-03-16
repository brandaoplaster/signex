defmodule Signex.Client.RequestTest do
  use ExUnit.Case, async: true

  import Mox
  alias Signex.Client.Request

  setup :verify_on_exit!

  @url "https://api.example.com"

  setup do
    TeslaMock
    |> stub(:call, fn env, _opts ->
      case env do
        %Tesla.Env{method: :get, url: @url} ->
          {:ok, %Tesla.Env{status: 200, body: %{"data" => "success"}}}

        %Tesla.Env{method: :post, url: @url} ->
          {:ok, %Tesla.Env{status: 201, body: %{"id" => 1}}}

        %Tesla.Env{method: :delete, url: @url} ->
          {:ok, %Tesla.Env{status: 204, body: ""}}

        %Tesla.Env{method: :put, url: @url} ->
          {:ok, %Tesla.Env{status: 200, body: %{"id" => 1, "key" => "updated_value"}}}

        %Tesla.Env{method: :patch, url: @url} ->
          {:ok, %Tesla.Env{status: 200, body: %{"id" => 1, "key" => "patched_value"}}}
      end
    end)

    {:ok, tesla_mock: TeslaMock}
  end

  describe "request/4" do
    test "returns {:ok, body} when GET request succeeds with 200 status" do
      assert {:ok, %{"data" => "success"}} = Request.request(:get, @url),
             "Expected successful GET to return {:ok, %{\"data\" => \"success\"}}"
    end

    test "returns {:ok, body} when POST request succeeds with 201 status" do
      assert {:ok, %{"id" => 1}} = Request.request(:post, @url, %{"key" => "value"}),
             "Expected successful POST to return {:ok, %{\"id\" => 1}}"
    end

    test "returns {:ok, body} when DELETE request succeeds with 204 status" do
      assert {:ok, ""} = Request.request(:delete, @url),
             "Expected successful DELETE to return {:ok, \"\"}"
    end

    test "returns {:ok, body} when PUT request succeeds with 200 status" do
      assert {:ok, %{"id" => 1, "key" => "updated_value"}} =
               Request.request(:put, @url, %{"key" => "value"}),
             "Expected successful PUT to return {:ok, %{\"id\" => 1, \"key\" => \"updated_value\"}}"
    end

    test "returns {:ok, body} when PATCH request succeeds with 200 status" do
      assert {:ok, %{"id" => 1, "key" => "patched_value"}} =
               Request.request(:patch, @url, %{"key" => "value"}),
             "Expected successful PATCH to return {:ok, %{\"id\" => 1, \"key\" => \"patched_value\"}}"
    end

    test "handles client error with 400 status", %{tesla_mock: tesla_mock} do
      stub(tesla_mock, :call, fn _, _ ->
        {:ok, %Tesla.Env{status: 400, body: %{"error" => "bad_request"}}}
      end)

      assert {:error, {:client_error, 400, %{"error" => "bad_request"}}} =
               Request.request(:get, @url)
    end

    test "handles server error with 500 status", %{tesla_mock: tesla_mock} do
      stub(tesla_mock, :call, fn _, _ ->
        {:ok, %Tesla.Env{status: 500, body: %{"error" => "server_error"}}}
      end)

      assert {:error, {:server_error, 500, %{"error" => "server_error"}}} =
               Request.request(:get, @url)
    end

    test "handles request timeout failure", %{tesla_mock: tesla_mock} do
      stub(tesla_mock, :call, fn _, _ -> {:error, :timeout} end)

      assert {:error, {:request_failed, :timeout}} =
               Request.request(:get, @url)
    end

    test "handles empty response body", %{tesla_mock: tesla_mock} do
      stub(tesla_mock, :call, fn _, _ -> {:ok, %Tesla.Env{status: 200, body: ""}} end)

      assert {:ok, ""} = Request.request(:get, @url)
    end
  end
end
