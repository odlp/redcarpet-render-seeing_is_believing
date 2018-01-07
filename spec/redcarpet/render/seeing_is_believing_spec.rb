require "nokogiri"
require "redcarpet"
require "rouge"
require "rouge/plugins/redcarpet"

class CustomHtmlRenderer < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet
  include Redcarpet::Render::SeeingIsBelieving
end

RSpec.describe Redcarpet::Render::SeeingIsBelieving do
  describe "#block_code" do
    context "code without opt-in flag" do
      it "is not enriched with code evaluation comments" do
        html = render_html_for_markdown CustomHtmlRenderer, <<~MD
          ```ruby
            foo = "bar"
            foo.upcase
          ```
        MD
        highlighted_code = extract_highlighted_ruby(html)

        expect(highlighted_code[0]).to eq 'foo = "bar"'
        expect(highlighted_code[1]).to eq 'foo.upcase'
      end
    end

    context "code with opt-in flag" do
      it "is enriched with code evaluation comments" do
        html = render_html_for_markdown CustomHtmlRenderer, <<~MD
          ```ruby+
            foo = "bar"
            foo.upcase
          ```
        MD
        highlighted_code = extract_highlighted_ruby(html)

        expect(highlighted_code[0]).to eq 'foo = "bar" # => "bar"'
        expect(highlighted_code[1]).to eq 'foo.upcase # => "BAR"'
      end
    end
  end

  private

  def render_html_for_markdown(renderer, markdown)
    options = { fenced_code_blocks: true }
    raw_html = Redcarpet::Markdown.new(renderer, options).render(markdown)
    Nokogiri::HTML(raw_html)
  end

  def extract_highlighted_ruby(html)
    html.css(".highlight .ruby").first.text.split("\n").map(&:strip)
  end
end
