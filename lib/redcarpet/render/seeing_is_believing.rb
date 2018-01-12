require "redcarpet/render/seeing_is_believing/enricher"
require "redcarpet/render/seeing_is_believing/options"
require "redcarpet/render/seeing_is_believing/version"

module Redcarpet
  module Render
    module SeeingIsBelieving
      def block_code(code, language)
        if language&.start_with? "ruby+"
          options = Options.parse(language)
          enriched_code = Enricher.new(options).process(code)
          super(enriched_code, "ruby")
        else
          super(code, language)
        end
      end
    end
  end
end
