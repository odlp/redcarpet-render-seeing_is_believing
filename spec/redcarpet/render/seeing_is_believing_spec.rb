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
    context "Ruby code without opt-in flag" do
      it "is not enriched with code evaluation comments" do
        html = render_html_for_markdown CustomHtmlRenderer, <<~MD
          ```ruby
            foo = "bar"
            foo.upcase
          ```
        MD
        highlighted_code = extract_highlighted_code(html)

        expect(highlighted_code[0]).to eq 'foo = "bar"'
        expect(highlighted_code[1]).to eq 'foo.upcase'
      end
    end

    context "code with no language specified" do
      it "is not enriched with code evaluation comments" do
        html = render_html_for_markdown CustomHtmlRenderer, <<~MD
          ```
            var a = true;
          ```
        MD
        highlighted_code = extract_highlighted_code(html)

        expect(highlighted_code[0]).to eq "var a = true;"
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
        highlighted_code = extract_highlighted_code(html)

        expect(highlighted_code[0]).to eq 'foo = "bar" # => "bar"'
        expect(highlighted_code[1]).to eq 'foo.upcase # => "BAR"'
      end

      describe "options" do
        it "passes the options to the enricher" do
          markdown = <<~MD
            ```ruby+e
              :foo
            ```
          MD

          options_class = Redcarpet::Render::SeeingIsBelieving::Options
          enricher_class = Redcarpet::Render::SeeingIsBelieving::Enricher

          enricher = instance_double(enricher_class, process: "")
          options = instance_double(options_class)

          expect(options_class).to receive(:parse).
            with("ruby+e").and_return(options)

          expect(enricher_class).to receive(:new).
            with(options).and_return(enricher)

          render_html_for_markdown(CustomHtmlRenderer, markdown)
        end
      end
    end
  end

  private

  def render_html_for_markdown(renderer, markdown)
    options = { fenced_code_blocks: true }
    raw_html = Redcarpet::Markdown.new(renderer, options).render(markdown)
    Nokogiri::HTML(raw_html)
  end

  def extract_highlighted_code(html)
    html.css(".highlight").first.text.split("\n").map(&:strip)
  end
end
