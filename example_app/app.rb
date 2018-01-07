require "pry"
require "redcarpet"
require "rouge"
require "rouge/plugins/redcarpet"
require "sinatra"
require_relative "../lib/redcarpet/render/seeing_is_believing"

class SiBHtmlRenderer < Redcarpet::Render::HTML
  def block_code(code, language)
    "<pre><code>#{code}</code></pre>"
  end

  prepend Redcarpet::Render::SeeingIsBelieving
end

class SiBRougeHtmlRenderer < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet
  prepend Redcarpet::Render::SeeingIsBelieving
end

get "/" do
  markdown_example = <<~MARKDOWN
    ```ruby+
      animals = ["Aardvark", "Butterfly", "Camel"]
      animals.map(&:upcase)
    ```
  MARKDOWN

  default_html = Redcarpet::Markdown.new(Redcarpet::Render::HTML, fenced_code_blocks: true).
    render(markdown_example)

  sib_html = Redcarpet::Markdown.new(SiBHtmlRenderer, fenced_code_blocks: true).
    render(markdown_example)

  sib_rouge_html = Redcarpet::Markdown.new(SiBRougeHtmlRenderer, fenced_code_blocks: true).
    render(markdown_example)

  css = Rouge::Theme.find("github").render(scope: ".highlight")

  <<~HTML
    <!doctype html>
    <html>
      <head>
          <meta charset="utf-8">
          <style media="screen">
            body  {
              margin: 20px;
              font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            }

            pre {
              background: #f8f8f8;
              padding: 10px;
              margin-bottom: 20px;
            }

            #{css}
          </style>
      </head>
      <body>
        <b>Default Redcarpet HTML renderer</b>
        #{default_html}

        <b>Seeing is Believing + custom Redcarpet HTML renderer</b>
        #{sib_html}

        <b>Rouge + Seeing is Believing + custom Redcarpet HTML renderer</b>
        #{sib_rouge_html}
      </body>
    </html>
  HTML
end
