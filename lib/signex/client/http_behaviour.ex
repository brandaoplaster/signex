defmodule Signex.Client.HttpBehaviour do
  @moduledoc """
    Defines the behavior for HTTP clients used in Signex API operations.

    This behavior establishes a consistent interface for HTTP client implementations,
    allowing different implementations (real HTTP, mock for testing, etc.)
    while maintaining a uniform API for resource modules.

    The defined callback functions represent the main HTTP methods:
    - post/2: Sends a POST request with a body and options
    - get/1: Performs a GET request with options
    - patch/2: Sends a PATCH request with a body and options
    - delete/1: Executes a DELETE request with options
  """

  @callback post(map(), keyword()) :: any()
  @callback get(keyword()) :: any()
  @callback patch(map(), keyword()) :: any()
  @callback delete(keyword()) :: any()
end
