# frozen_string_literal: true

require "json"
require_relative "jsonc/version"
require_relative "jsonc/parser"

module JSONC
  class Error < StandardError; end

  DEFAULT_MAX_BYTES = 10_485_760 # 10MB

  def self.parse(string, **opts)
    max_bytes = opts.delete(:max_bytes) || DEFAULT_MAX_BYTES
    if string.bytesize > max_bytes
      raise JSON::ParserError,
            "input string too large (#{string.bytesize} bytes, max #{max_bytes} bytes)"
    end

    sanitized_string = Parser.parse(string)
    JSON.parse(sanitized_string, **opts)
  end

  def self.load_file(path, **opts)
    parse(File.read(path), **opts)
  end
end
