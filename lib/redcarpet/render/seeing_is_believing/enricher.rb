require "seeing_is_believing"
require_relative "options"

module Redcarpet
  module Render
    module SeeingIsBelieving
      class Enricher
        def initialize(options = Options.new)
          @options = options
        end

        def process(code)
          result = evaluate_code(code)
          combine_code_with_result(code.split("\n"), result).join("\n")
        end

        private

        attr_reader :options

        def evaluate_code(code)
          ::SeeingIsBelieving.call(code).result
        end

        def combine_code_with_result(code_lines, result)
          code_lines.map.with_index(1) do |code_line, line_no|
            eval_lines = result[line_no]
            exception = result.exceptions.
              detect { |ex| ex.line_number == line_no }

            if eval_lines.any?
              code_line + " # => " + eval_lines.join("\n")
            elsif options.show_exceptions && exception
              code_line + " # => #{exception.class_name}: #{exception.message}"
            else
              code_line
            end
          end
        end

      end
    end
  end
end
