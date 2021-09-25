# frozen_string_literal: true

require 'microsoft_teams_incoming_webhook_ruby'

def generate_html_with(env)
  StringIO.new <<-HTML
    <!DOCTYPE html>
    <html>
      <head>
        <meta charset='utf-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1'>
        <title>Microsoft Teams Incoming Webhook Ruby - Demo App</title>
      </head>
      <body>
        Demo in progress ...
      </body>
    </html>
  HTML
end

run lambda { |env|
  [
    200,
    {
      'Content-Type' => 'text/html'
    },
    generate_html_with(env)
  ]
}
