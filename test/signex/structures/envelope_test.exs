defmodule Signex.Structures.EnvelopeTest do
  use ExUnit.Case, async: true

  alias Signex.Structures.Envelope

  describe "build/1" do
    test "successfully creates an envelope with valid required attributes" do
      attrs = %{
        name: "Test Envelope",
        locale: "en",
        auto_close: true,
        remind_interval: "7",
        block_after_refusal: false
      }

      assert {:ok, %Envelope{} = envelope} = Envelope.build(attrs)
      assert envelope.name == "Test Envelope"
      assert envelope.locale == "en"
      assert envelope.auto_close == true
      assert envelope.remind_interval == "7"
      assert envelope.block_after_refusal == false
      assert envelope.deadline_at == nil
      assert envelope.default_subject == nil
      assert envelope.default_message == nil
    end

    test "successfully creates an envelope with all valid attributes" do
      attrs = %{
        name: "Test Envelope",
        locale: "en",
        auto_close: true,
        remind_interval: "7",
        block_after_refusal: false,
        deadline_at: "2025-12-31T23:59:59Z",
        default_subject: "Test Subject",
        default_message: "Test Message"
      }

      assert {:ok, %Envelope{} = envelope} = Envelope.build(attrs)
      assert envelope.deadline_at == "2025-12-31T23:59:59Z"
      assert envelope.default_subject == "Test Subject"
      assert envelope.default_message == "Test Message"
    end

    test "fails when required fields are missing" do
      attrs = %{
        name: "Test Envelope",
        locale: "en"
      }

      assert {:error, "Missing required fields: " <> missing} = Envelope.build(attrs)
      assert missing =~ "auto_close"
      assert missing =~ "remind_interval"
      assert missing =~ "block_after_refusal"
    end

    test "fails when fields have invalid types" do
      attrs = %{
        # should be string
        name: 123,
        locale: "en",
        # should be boolean
        auto_close: "true",
        remind_interval: "7",
        block_after_refusal: false
      }

      assert {:error, "Invalid type for name"} = Envelope.build(attrs)
    end

    test "fails when deadline_at has invalid format" do
      attrs = %{
        name: "Test Envelope",
        locale: "en",
        auto_close: true,
        remind_interval: "7",
        block_after_refusal: false,
        # invalid format
        deadline_at: "2025-12-31"
      }

      assert {:error, "Invalid deadline_at format, expected (YYYY-MM-DDTHH:MM:SSZ)"} =
               Envelope.build(attrs)
    end

    test "fails when remind_interval is not an allowed value" do
      attrs = %{
        name: "Test Envelope",
        locale: "en",
        auto_close: true,
        # invalid value
        remind_interval: "5",
        block_after_refusal: false
      }

      assert {:error, "Invalid remind_interval, Allowed values: 1, 2, 3, 7, 14"} =
               Envelope.build(attrs)
    end

    test "accepts nil for optional fields default_subject and default_message" do
      attrs = %{
        name: "Test Envelope",
        locale: "en",
        auto_close: true,
        remind_interval: "7",
        block_after_refusal: false,
        default_subject: nil,
        default_message: nil
      }

      assert {:ok, %Envelope{}} = Envelope.build(attrs)
    end
  end
end
