# frozen_string_literal: true

require "spec_helper"
require "jsonc"
require "tempfile"

RSpec.describe JSONC do
  let(:jsonc_string) do
    <<~JSONC
      {
        // This file has everything.
        "name": "Jules",
        "is_agent": true, /* and a block comment */
        "skills": [
          "Ruby",
          "Go",
          "Planning",
        ],
      }
    JSONC
  end

  let(:expected_hash) do
    {
      "name" => "Jules",
      "is_agent" => true,
      "skills" => %w[Ruby Go Planning]
    }
  end

  describe ".parse" do
    it "correctly parses a complex JSONC string" do
      expect(described_class.parse(jsonc_string)).to eq(expected_hash)
    end

    it "forwards options to the underlying parser" do
      symbolized_hash = expected_hash.transform_keys(&:to_sym)
      expect(described_class.parse(jsonc_string, symbolize_names: true)).to eq(symbolized_hash)
    end

    context "with size limit" do
      it "rejects input exceeding default max_bytes (10MB)" do
        large_string = "{\"data\": \"#{"a" * 10_485_760}\"}"
        expect { described_class.parse(large_string) }
          .to raise_error(JSON::ParserError, /input string too large/)
      end

      it "accepts input within default max_bytes" do
        large_string = "{\"data\": \"#{"a" * 1_000_000}\"}"
        expect { described_class.parse(large_string) }.not_to raise_error
      end

      it "respects custom max_bytes option" do
        small_string = '{"data": "test"}'
        expect { described_class.parse(small_string, max_bytes: 5) }
          .to raise_error(JSON::ParserError, /input string too large/)
      end

      it "allows larger input with custom max_bytes" do
        large_string = "{\"data\": \"#{"a" * 15_000_000}\"}"
        expect { described_class.parse(large_string, max_bytes: 20_000_000) }.not_to raise_error
      end

      it "uses default max_bytes when max_bytes: nil is passed" do
        small_string = '{"data": "test"}'
        expect { described_class.parse(small_string, max_bytes: nil) }.not_to raise_error
      end
    end
  end

  describe ".load_file" do
    it "correctly loads and parses a complex JSONC file" do
      Tempfile.create(["test", ".jsonc"]) do |file|
        file.write(jsonc_string)
        file.rewind
        expect(described_class.load_file(file.path)).to eq(expected_hash)
      end
    end

    it "rejects files exceeding max_bytes limit" do
      Tempfile.create(["test", ".jsonc"]) do |file|
        file.write("{\"data\": \"#{"a" * 10_485_760}\"}")
        expect { described_class.load_file(file.path) }.to raise_error(JSON::ParserError, /too large/)
      end
    end

    it "accepts files within max_bytes limit" do
      Tempfile.create(["test", ".jsonc"]) do |file|
        file.write("{\"data\": \"#{"a" * 1_000_000}\"}")
        expect { described_class.load_file(file.path) }.not_to raise_error
      end
    end

    it "does not raise error when max_bytes: nil is passed" do
      Tempfile.create(["test", ".jsonc"]) do |file|
        file.write(jsonc_string)
        file.rewind
        expect { described_class.load_file(file.path, max_bytes: nil) }.not_to raise_error
      end
    end

    it "correctly parses when max_bytes: nil is passed" do
      Tempfile.create(["test", ".jsonc"]) do |file|
        file.write(jsonc_string)
        file.rewind
        expect(described_class.load_file(file.path, max_bytes: nil)).to eq(expected_hash)
      end
    end
  end
end
