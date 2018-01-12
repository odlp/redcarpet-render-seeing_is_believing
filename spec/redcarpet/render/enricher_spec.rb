RSpec.describe Redcarpet::Render::SeeingIsBelieving::Enricher do
  describe "blank lines" do
    it "doesn't add a comment" do
      code = <<~CODE

        "bar".upcase
      CODE

      enriched_code = subject.process(code).split("\n")

      expect(enriched_code[0]).to be_empty
      expect(enriched_code[1]).to eq '"bar".upcase # => "BAR"'
    end
  end

  describe "evaluating Ruby code with exceptions" do
    it "supresses exceptions by default" do
      code = <<~CODE
        "bar".upcase
        BROKEN
      CODE

      enriched_code = subject.process(code).split("\n")

      expect(enriched_code[0]).to eq '"bar".upcase # => "BAR"'
      expect(enriched_code[1]).to eq "BROKEN"
    end

    it "allows exceptions to be shown" do
      code = <<~CODE
        "bar".upcase
        BROKEN
      CODE

      options = Redcarpet::Render::SeeingIsBelieving::Options.new(
        show_exceptions: true
      )

      enriched_code = described_class.new(options).process(code).split("\n")

      expect(enriched_code[0]).to eq '"bar".upcase # => "BAR"'
      expect(enriched_code[1]).
        to eq "BROKEN # => NameError: uninitialized constant BROKEN"
    end
  end
end
