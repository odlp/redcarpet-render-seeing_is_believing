require "seeing_is_believing"

module Redcarpet
  module Render
    module SeeingIsBelieving
      class Enricher
        def process(code)
          evaluated_code = ::SeeingIsBelieving.call(code).result

          code.split("\n").
            zip(evaluated_code).
            map do |code_line, eval_lines|
              if eval_lines.any?
                code_line + " # => " + eval_lines.join("\n")
              else
                code_line
              end
            end.
            join("\n")
        end
      end
    end
  end
end
