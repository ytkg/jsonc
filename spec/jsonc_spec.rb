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
  end

  describe ".load_file" do
    it "correctly loads and parses a complex JSONC file" do
      Tempfile.create(["test", ".jsonc"]) do |file|
        file.write(jsonc_string)
        file.rewind
        expect(described_class.load_file(file.path)).to eq(expected_hash)
      end
    end
  end
end
