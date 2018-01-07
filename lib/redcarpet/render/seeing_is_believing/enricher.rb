require "seeing_is_believing"

module Redcarpet
  module Render
    module SeeingIsBelieving
      class Enricher
        def process(code)
          code.split("\n").
            zip(evaluate_code(code)).
            map(&combine_code_and_eval_lines).
            join("\n")
        end

        private

        def evaluate_code(code)
          ::SeeingIsBelieving.call(code).result
        end

        def combine_code_and_eval_lines
          proc do |code_line, eval_lines|
            if eval_lines.any?
              code_line + " # => " + eval_lines.join("\n")
            else
              code_line
            end
          end
        end
      end
    end
  end
end
