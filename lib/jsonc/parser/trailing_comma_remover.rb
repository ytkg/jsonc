# frozen_string_literal: true

module JSONC
  class Parser
    class TrailingCommaRemover
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
          end
        end
        @result
      end

      private

      def parse_normal
        char = @string[@index]
        if char == '"'
          @state = :in_string
          @result << char
        elsif char == ","
          @result << char unless find_next_meaningful_char_is_closing_bracket?
        else
          @result << char
        end
        @index += 1
      end

      def parse_string # rubocop:disable Metrics/MethodLength
        char = @string[@index]
        if char == "\\"
          @result << char
          if @index + 1 < @string.length
            @result << @string[@index + 1]
            @index += 2
          else
            @index += 1
          end
        elsif char == '"'
          @state = :normal
          @result << char
          @index += 1
        else
          @result << char
          @index += 1
        end
      end

      def find_next_meaningful_char_is_closing_bracket?
        i = @index + 1
        while i < @string.length
          char = @string[i]
          return true if ["]", "}"].include?(char)
          return false unless char.strip.empty?

          i += 1
        end
        false
      end
    end
  end
end
