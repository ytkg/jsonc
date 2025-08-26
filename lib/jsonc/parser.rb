# frozen_string_literal: true

require_relative "parser/comment_remover"
require_relative "parser/trailing_comma_remover"

module JSONC
  # The main parser class. It orchestrates the removal of comments and trailing commas.
  class Parser
    def self.parse(string)
      comment_free_string = CommentRemover.new(string).parse
      TrailingCommaRemover.new(comment_free_string).parse
    end
  end
end
