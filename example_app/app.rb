require "pry"
require "redcarpet"
require "rouge"
require "rouge/plugins/redcarpet"
require "sinatra"
require_relative "../lib/redcarpet/render/seeing_is_believing"

class SiBHtmlRenderer < Redcarpet::Render::HTML
  prepend Redcarpet::Render::SeeingIsBelieving

  def block_code(code, language)
    "<pre><code>#{code}</code></pre>"
  end
end

class SiBRougeHtmlRenderer < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet
  prepend Redcarpet::Render::SeeingIsBelieving
end

get "/" do
  markdown = <<~MARKDOWN
    ```ruby+
      animals = ["Aardvark", "Butterfly", "Camel"]
      animals.map(&:upcase)
    ```
  MARKDOWN

  options = { fenced_code_blocks: true }

  default_html =
    Redcarpet::Markdown.new(Redcarpet::Render::HTML, options).render(markdown)

  sib_html =
    Redcarpet::Markdown.new(SiBHtmlRenderer, options).render(markdown)

  sib_rouge_html =
    Redcarpet::Markdown.new(SiBRougeHtmlRenderer, options).render(markdown)

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
        <b>Redcarpet HTML renderer</b>
        #{default_html}

        <b>Seeing is Believing + Redcarpet HTML renderer</b>
        #{sib_html}

        <b>Rouge + Seeing is Believing + Redcarpet HTML renderer</b>
        #{sib_rouge_html}
      </body>
    </html>
  HTML
end
