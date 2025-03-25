defmodule Signex.Structures.DocumentTest do
  use ExUnit.Case, async: true

  alias Signex.Structures.Document

  describe "build/1" do
    test "successfully builds a Document when all required fields are present with correct types" do
      attrs = %{
        filename: "test.pdf",
        # "Hello World" em base64
        content_base64: "SGVsbG8gV29ybGQ="
      }

      assert {:ok, %Document{} = doc} = Document.build(attrs)
      assert doc.filename == "test.pdf"
      assert doc.content_base64 == "SGVsbG8gV29ybGQ="
    end

    test "returns error when filename is missing" do
      attrs = %{
        content_base64: "SGVsbG8gV29ybGQ="
      }

      assert {:error, "Missing required fields: [:filename]"} = Document.build(attrs)
    end

    test "returns error when content_base64 is missing" do
      attrs = %{
        filename: "test.pdf"
      }

      assert {:error, "Missing required fields: [:content_base64]"} = Document.build(attrs)
    end

    test "returns error when both required fields are missing" do
      attrs = %{}

      assert {:error, message} = Document.build(attrs)
      assert message =~ "Missing required fields"
      assert String.contains?(message, ":content_base64")
      assert String.contains?(message, ":filename")
    end

    test "returns error when filename is not a string" do
      attrs = %{
        filename: 123,
        content_base64: "SGVsbG8gV29ybGQ="
      }

      assert {:error, "invalid type for filename"} = Document.build(attrs)
    end

    test "returns error when content_base64 is not a string" do
      attrs = %{
        filename: "test.pdf",
        content_base64: :not_a_string
      }

      assert {:error, "invalid type for content_base64"} = Document.build(attrs)
    end

    test "ignores extra fields in the input map" do
      attrs = %{
        filename: "test.pdf",
        content_base64: "SGVsbG8gV29ybGQ=",
        extra_field: "ignored"
      }

      assert {:ok, %Document{} = doc} = Document.build(attrs)
      assert doc.filename == "test.pdf"
      assert doc.content_base64 == "SGVsbG8gV29ybGQ="
      refute Map.has_key?(doc, :extra_field)
    end
  end
end
