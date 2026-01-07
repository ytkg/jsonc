# frozen_string_literal: true

require "spec_helper"
require "jsonc/parser/comment_remover"

RSpec.describe JSONC::Parser::CommentRemover do
  let(:parser) { described_class.new(input) }

  # Helper to compare JSON strings ignoring whitespace differences
  def expect_json_string_to_equal(actual, expected)
    # A simple way to ignore whitespace is to parse and re-generate,
    # but that introduces a dependency on the JSON parser itself.
    # Instead, we'll just remove all whitespace from both strings.
    expect(actual.gsub(/\s+/, "")).to eq(expected.gsub(/\s+/, ""))
  end

  describe "#parse" do
    context "with line comments" do
      let(:input) do
        <<~JSONC
          {
            // This is a line comment.
            "name": "Jules", // Another line comment.
            "is_agent": true
          }
        JSONC
      end
      let(:expected_output) do
        <<~JSON
          {
            "name": "Jules",
            "is_agent": true
          }
        JSON
      end

      it "strips the comments" do
        expect_json_string_to_equal(parser.parse, expected_output)
      end
    end

    context "with block comments" do
      let(:input) do
        <<~JSONC
          {
            /* This is a block comment.
               It can span multiple lines. */
            "name": "Jules",
            "is_agent": true /* Another block comment. */
          }
        JSONC
      end
      let(:expected_output) do
        <<~JSON
          {
            "name": "Jules",
            "is_agent": true
          }
        JSON
      end

      it "strips the comments" do
        expect_json_string_to_equal(parser.parse, expected_output)
      end
    end

    context "when comment-like syntax appears in strings" do
      let(:input) do
        <<~JSONC
          {
            "url": "https://example.com",
            "message": "This is not a /* block comment */",
            "code": "a = 1; // This is not a line comment"
          }
        JSONC
      end

      it "does not strip them" do
        expect(parser.parse).to eq(input)
      end
    end

    context "with unclosed block comments" do
      let(:input) { '{"a": 1} /* oops' }

      it "raises a parser error" do
        expect { parser.parse }.to raise_error(JSON::ParserError, "Unclosed block comment")
      end
    end

    context "when input ends with backslash in a string" do
      let(:input) { '{"text": "test\\' }

      it "handles out-of-bounds access gracefully" do
        result = parser.parse
        expect(result).to eq('{"text": "test\\')
      end
    end

    context "with normal escape sequences" do
      let(:input) { '{"text": "test\n\t\"\\path"}' }

      it "preserves them correctly" do
        result = parser.parse
        expect(result).to eq('{"text": "test\n\t\"\\path"}')
      end
    end
  end
end
