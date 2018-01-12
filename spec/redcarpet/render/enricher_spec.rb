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
end
