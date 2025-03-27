defmodule Signex.Structures.CommunicateEventTest do
  use ExUnit.Case, async: true

  alias Signex.Structures.CommunicateEvent

  describe "build/1" do
    test "successfully builds with all valid fields provided" do
      attrs = %{
        signature_request: "whatsapp",
        signature_reminder: "email",
        document_signed: "whatsapp"
      }

      assert {:ok, %CommunicateEvent{} = event} = CommunicateEvent.build(attrs)
      assert event.signature_request == "whatsapp"
      assert event.signature_reminder == "email"
      assert event.document_signed == "whatsapp"
    end

    # test "uses default 'email' when no fields are provided" do
    #   attrs = %{}

    #   assert {:ok, %CommunicateEvent{} = event} = CommunicateEvent.build(attrs)
    #   assert event.signature_request == "email"
    #   assert event.signature_reminder == "email"
    #   assert event.document_signed == "email"
    # end

    # test "works with partial fields, using default for missing ones" do
    #   attrs = %{signature_request: "sms"}

    #   assert {:ok, %CommunicateEvent{} = event} = CommunicateEvent.build(attrs)
    #   assert event.signature_request == "sms"
    #   assert event.signature_reminder == "email"
    #   assert event.document_signed == "email"
    # end

    test "returns error for invalid signature_request value" do
      attrs = %{signature_request: "invalid"}

      assert {:error, "Invalid value for signature_request"} = CommunicateEvent.build(attrs)
    end

    test "returns error for invalid signature_reminder value" do
      attrs = %{
        signature_request: "sms",
        # "sms" não é permitido para signature_reminder
        signature_reminder: "sms"
      }

      assert {:error, "Invalid value for signature_reminder"} = CommunicateEvent.build(attrs)
    end

    test "returns error for invalid document_signed value" do
      attrs = %{
        signature_request: "email",
        # "sms" não é permitido para document_signed
        document_signed: "sms"
      }

      assert {:error, "Invalid value for document_signed"} = CommunicateEvent.build(attrs)
    end

    test "stops validation at first error" do
      attrs = %{
        signature_request: "invalid",
        signature_reminder: "invalid",
        document_signed: "invalid"
      }

      # Só reporta o erro do signature_request, pois a validação é sequencial
      assert {:error, "Invalid value for signature_request"} = CommunicateEvent.build(attrs)
    end

    test "accepts all valid options for signature_request" do
      for option <- ["sms", "email", "whatsapp"] do
        attrs = %{signature_request: option}
        assert {:ok, %CommunicateEvent{} = event} = CommunicateEvent.build(attrs)
        assert event.signature_request == option
      end
    end

    test "accepts all valid options for signature_reminder" do
      for option <- ["email", "whatsapp"] do
        attrs = %{signature_reminder: option}
        assert {:ok, %CommunicateEvent{} = event} = CommunicateEvent.build(attrs)
        assert event.signature_reminder == option
      end
    end

    test "accepts all valid options for document_signed" do
      for option <- ["email", "whatsapp"] do
        attrs = %{document_signed: option}
        assert {:ok, %CommunicateEvent{} = event} = CommunicateEvent.build(attrs)
        assert event.document_signed == option
      end
    end
  end
end
