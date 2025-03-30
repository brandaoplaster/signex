defmodule Signex.Client.Response do
  @moduledoc """

  """

  def handle({:ok, %Tesla.Env{status: 201} = env}) do
    handle_success(env)
  end

  def handle({:ok, %Tesla.Env{status: status, body: body}}) when status in [400, 422, 503] do
    handle_error(status, body)
  end

  def handle({:ok, %Tesla.Env{status: status, body: body}}) do
    {:error, "Status inesperado: #{status}, resposta: #{inspect(body)}"}
  end

  def handle({:error, reason}) do
    {:error, "Erro na requisição: #{format_error_reason(reason)}"}
  end

  defp handle_success(%Tesla.Env{body: %{"data" => %{"id" => id}}}) do
    {:ok, id}
  end

  defp handle_success(%Tesla.Env{body: body}) do
    {:error, "Resposta 201 inválida: #{inspect(body)}"}
  end

  defp handle_error(status, %{"errors" => errors}) when is_list(errors) do
    error_details = Enum.map_join(errors, "; ", &format_error_detail/1)
    {:error, "Falha na requisição (status #{status}): #{error_details}"}
  end

  defp handle_error(status, body) do
    {:error, "Falha na requisição (status #{status}): #{inspect(body)}"}
  end

  defp format_error_detail(%{
         "code" => code,
         "detail" => detail,
         "source" => %{"pointer" => pointer}
       }) do
    "#{code} - #{detail} (#{pointer})"
  end

  defp format_error_detail(%{"code" => code, "detail" => detail}) do
    "#{code} - #{detail}"
  end

  defp format_error_detail(%{"detail" => detail}) do
    detail
  end

  defp format_error_detail(error) do
    inspect(error)
  end

  defp format_error_reason(%Tesla.Error{reason: reason}), do: inspect(reason)
  defp format_error_reason(reason), do: inspect(reason)
end
