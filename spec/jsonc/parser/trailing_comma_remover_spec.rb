# frozen_string_literal: true

require "spec_helper"
require "jsonc/parser/trailing_comma_remover"

RSpec.describe JSONC::Parser::TrailingCommaRemover do
  let(:parser) { described_class.new(input) }

  describe "#parse" do
    context "with a trailing comma in an object" do
      let(:input) { '{"a": 1, "b": 2,}' }

      it "removes the trailing comma" do
        expect(parser.parse).to eq('{"a": 1, "b": 2}')
      end
    end

    context "with a trailing comma in an array" do
      let(:input) { "[1, 2, 3, ]" }

      it "removes the trailing comma" do
        expect(parser.parse).to eq("[1, 2, 3 ]")
      end
    end

    context "with a trailing comma and trailing whitespace" do
      let(:input) { '{"a": 1, }  ' }

      it "removes the trailing comma" do
        expect(parser.parse).to eq('{"a": 1 }  ')
      end
    end

    context "with a valid comma" do
      let(:input) { '{"a": 1, "b": 2}' }

      it "does not remove it" do
        expect(parser.parse).to eq(input)
      end
    end

    context "with a comma in a string" do
      let(:input) { '{"a": "hello, world,"}' }

      it "does not remove it" do
        expect(parser.parse).to eq(input)
      end
    end
  end
end
