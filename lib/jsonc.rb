# frozen_string_literal: true

require "json"
require_relative "jsonc/version"
require_relative "jsonc/parser"

module JSONC
  class Error < StandardError; end

  def self.parse(string, **opts)
    sanitized_string = Parser.parse(string)
    JSON.parse(sanitized_string, **opts)
  end

  def self.load_file(path, **opts)
    parse(File.read(path), **opts)
  end
end
