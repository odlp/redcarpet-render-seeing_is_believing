module Redcarpet
  module Render
    module SeeingIsBelieving
      class Options
        attr_reader :show_exceptions

        def self.parse(language)
          options = language.partition("+").last

          new(show_exceptions: options.include?("e"))
        end

        def initialize(show_exceptions: false)
          @show_exceptions = show_exceptions
        end
      end
    end
  end
end
