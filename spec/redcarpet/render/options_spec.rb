RSpec.describe Redcarpet::Render::SeeingIsBelieving::Options do
  describe "#parse" do
    it "determines if exceptions should be shown" do
      expect(parse_options("ruby+").show_exceptions).to be false
      expect(parse_options("ruby+e").show_exceptions).to be true
    end

    private

    def parse_options(language)
      described_class.parse(language)
    end
  end
end
