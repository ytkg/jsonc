# frozen_string_literal: true

module JSONC
  class Parser
    class CommentRemover
      def initialize(string)
        @string = string
        @index = 0
        @result = String.new
        @state = :normal
      end

      def parse
        while @index < @string.length
          case @state
          when :normal then parse_normal
          when :in_string then parse_string
          when :in_line_comment then parse_line_comment
          when :in_block_comment then parse_block_comment
          end
        end
        raise JSON::ParserError, "Unclosed block comment" if @state == :in_block_comment

        @result
      end

      private

      # rubocop:disable Metrics/MethodLength
      def parse_normal
        char = @string[@index]
        if char == '"'
          @state = :in_string
          @result << char
          @index += 1
        elsif char == "/" && @string[@index + 1] == "/"
          @state = :in_line_comment
          @index += 2
        elsif char == "/" && @string[@index + 1] == "*"
          @state = :in_block_comment
          @index += 2
        else
          @result << char
          @index += 1
        end
      end
      # rubocop:enable Metrics/MethodLength

      # rubocop:disable Metrics/MethodLength
      def parse_string
        char = @string[@index]
        if char == "\\"
          @result << char << @string[@index + 1]
          @index += 2
        elsif char == '"'
          @state = :normal
          @result << char
          @index += 1
        else
          @result << char
          @index += 1
        end
      end
      # rubocop:enable Metrics/MethodLength

      def parse_line_comment
        char = @string[@index]
        if char == "\n"
          @state = :normal
          @result << char
        end
        @index += 1
      end

      def parse_block_comment
        char = @string[@index]
        if char == "*" && @string[@index + 1] == "/"
          @state = :normal
          @index += 2
        else
          @result << "\n" if char == "\n"
          @index += 1
        end
      end
    end
  end
end
