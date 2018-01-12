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
          code.split("\n").
            zip(evaluate_code(code)).
            map(&combine_code_with_result).
            join("\n")
        end

        private

        attr_reader :options

        def evaluate_code(code)
          eval_result = ::SeeingIsBelieving.call(code).result
          combine_eval_lines_and_exceptions(eval_result)
        end

        def combine_eval_lines_and_exceptions(result)
          (1..result.num_lines).map do |line_number|
            eval_lines = result[line_number]
            exception = exception_for_line(result.exceptions, line_number)

            if eval_lines.any?
              eval_lines.join(" ")
            elsif exception
              "#{exception.class_name}: #{exception.message}"
            end
          end
        end

        def exception_for_line(exceptions, line_number)
          if options.show_exceptions
            exceptions.detect { |ex| ex.line_number == line_number }
          end
        end

        def combine_code_with_result
          proc do |code_line, eval_line|
            if eval_line
              "#{code_line} # => #{eval_line}"
            else
              code_line
            end
          end
        end

      end
    end
  end
end
