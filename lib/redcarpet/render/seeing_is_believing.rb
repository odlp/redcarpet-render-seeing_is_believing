require "redcarpet/render/seeing_is_believing/version"
require "seeing_is_believing"

module Redcarpet
  module Render
    module SeeingIsBelieving
      def block_code(code, language)
        if language != "ruby+"
          return super(code, language)
        end

        evaluated_code = ::SeeingIsBelieving.call(code).result
        enriched_code = code.split("\n").
          zip(evaluated_code).
          map do |code_line, eval_lines|
            code_line + " # => " + eval_lines.join("\n")
          end

        super(enriched_code.join("\n"), "ruby")
      end
    end
  end
end
