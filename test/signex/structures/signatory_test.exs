defmodule Signex.Structures.SignatoryTest do
  use ExUnit.Case, async: true

  alias Signex.Structures.Signatory

  describe "build/1" do
    test "successfully builds with only required fields" do
      attrs = %{
        name: "John Smith",
        email: "john@example.com",
        phone_number: "+5511999999999"
      }

      assert {:ok, %Signatory{} = signatory} = Signatory.build(attrs)
      assert signatory.name == "John Smith"
      assert signatory.email == "john@example.com"
      assert signatory.phone_number == "+5511999999999"
      assert signatory.birthday == nil
      assert signatory.refusable == nil
    end

    test "successfully builds with all fields" do
      attrs = %{
        name: "John Smith",
        email: "john@example.com",
        phone_number: "+5511999999999",
        birthday: ~D[1990-01-01],
        has_document: "yes",
        documentation: "123456789",
        refusable: false,
        group: 1,
        location_required_enabled: true
      }

      assert {:ok, %Signatory{} = signatory} = Signatory.build(attrs)
      assert signatory.name == "John Smith"
      assert signatory.email == "john@example.com"
      assert signatory.phone_number == "+5511999999999"
      assert signatory.birthday == ~D[1990-01-01]
      assert signatory.has_document == "yes"
      assert signatory.documentation == "123456789"
      assert signatory.refusable == false
      assert signatory.group == 1
      assert signatory.location_required_enabled == true
    end

    test "returns error when all required fields are missing" do
      attrs = %{}

      assert {:error, "Missing required fields: [\"name\", \"email\", \"phone_number\"]"} =
               Signatory.build(attrs)
    end

    test "returns error when some required fields are missing" do
      attrs = %{name: "John"}

      assert {:error, "Missing required fields: [\"email\", \"phone_number\"]"} =
               Signatory.build(attrs)
    end

    test "returns error for invalid name type" do
      attrs = %{
        name: 123,
        email: "john@example.com",
        phone_number: "+5511999999999"
      }

      assert {:error, {:invalid_types, [{:name, "must be a string"}]}} = Signatory.build(attrs)
    end

    test "returns error for invalid email type" do
      attrs = %{
        name: "John Smith",
        email: :not_a_string,
        phone_number: "+5511999999999"
      }

      assert {:error, {:invalid_types, [{:email, "must be a string"}]}} = Signatory.build(attrs)
    end

    test "returns error for invalid phone_number type" do
      attrs = %{
        name: "John Smith",
        email: "john@example.com",
        phone_number: 123
      }

      assert {:error, {:invalid_types, [{:phone_number, "must be a string"}]}} =
               Signatory.build(attrs)
    end

    test "returns error for invalid birthday type" do
      attrs = %{
        name: "John Smith",
        email: "john@example.com",
        phone_number: "+5511999999999",
        birthday: "1990-01-01"
      }

      assert {:error, {:invalid_types, [{:birthday, "must be a valid date"}]}} =
               Signatory.build(attrs)
    end

    test "returns error for invalid has_document type" do
      attrs = %{
        name: "John Smith",
        email: "john@example.com",
        phone_number: "+5511999999999",
        has_document: true
      }

      assert {:error, {:invalid_types, [{:has_document, "must be a string"}]}} =
               Signatory.build(attrs)
    end

    test "returns error for invalid documentation type" do
      attrs = %{
        name: "John Smith",
        email: "john@example.com",
        phone_number: "+5511999999999",
        documentation: 123
      }

      assert {:error, {:invalid_types, [{:documentation, "must be a string"}]}} =
               Signatory.build(attrs)
    end

    test "returns error for invalid refusable type" do
      attrs = %{
        name: "John Smith",
        email: "john@example.com",
        phone_number: "+5511999999999",
        refusable: "false"
      }

      assert {:error, {:invalid_types, [{:refusable, "must be a boolean"}]}} =
               Signatory.build(attrs)
    end

    test "returns error for invalid group type" do
      attrs = %{
        name: "John Smith",
        email: "john@example.com",
        phone_number: "+5511999999999",
        group: "1"
      }

      assert {:error, {:invalid_types, [{:group, "must be an integer"}]}} = Signatory.build(attrs)
    end

    test "returns error for invalid location_required_enabled type" do
      attrs = %{
        name: "John Smith",
        email: "john@example.com",
        phone_number: "+5511999999999",
        location_required_enabled: "true"
      }

      assert {:error, {:invalid_types, [{:location_required_enabled, "must be a boolean"}]}} =
               Signatory.build(attrs)
    end

    test "returns error for multiple invalid types" do
      attrs = %{
        name: 123,
        email: "john@example.com",
        phone_number: :not_a_string,
        birthday: "1990-01-01"
      }

      assert {:error, {:invalid_types, errors}} = Signatory.build(attrs)
      assert length(errors) == 3
      assert Enum.any?(errors, &(&1 == {:name, "must be a string"}))
      assert Enum.any?(errors, &(&1 == {:phone_number, "must be a string"}))
      assert Enum.any?(errors, &(&1 == {:birthday, "must be a valid date"}))
    end
  end
end
