# Microsoft Teams Incoming Webhook Ruby

[![CI](https://github.com/pedrofurtado/microsoft_teams_incoming_webhook_ruby/actions/workflows/ci.yml/badge.svg)](https://github.com/pedrofurtado/microsoft_teams_incoming_webhook_ruby/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/pedrofurtado/microsoft_teams_incoming_webhook_ruby/branch/master/graph/badge.svg?token=R8QOY8Y6W8)](https://codecov.io/gh/pedrofurtado/microsoft_teams_incoming_webhook_ruby)
[![Maintainability](https://api.codeclimate.com/v1/badges/31748863989fd026ad25/maintainability)](https://codeclimate.com/github/pedrofurtado/microsoft_teams_incoming_webhook_ruby/maintainability)
[![Gem Version](https://badge.fury.io/rb/microsoft_teams_incoming_webhook_ruby.svg)](https://badge.fury.io/rb/microsoft_teams_incoming_webhook_ruby)
[![Gem](https://img.shields.io/gem/dt/microsoft_teams_incoming_webhook_ruby.svg)]()
[![license](https://img.shields.io/github/license/pedrofurtado/microsoft_teams_incoming_webhook_ruby.svg)]()
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)](https://github.com/pedrofurtado/microsoft_teams_incoming_webhook_ruby)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)

Ruby gem for integration with Microsoft Teams Incoming Webhook.

<img style="max-width: 100%;" src="https://github.com/pedrofurtado/microsoft_teams_incoming_webhook_ruby/blob/master/microsoft_teams.png?raw=true" height="100px" />

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'microsoft_teams_incoming_webhook_ruby'
```

And then execute:

```shell
bundle install
```

Or install it yourself as:

```shell
gem install microsoft_teams_incoming_webhook_ruby
```

## Usage

### Configuration of Incoming Webhook connector on your Teams channels

The first step before using this gem is to configure the connector inside your Team channels.

For this purpose, please check the official documentation from Microsoft. It's listed below some useful links:

- https://docs.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhook#create-incoming-webhook-1
- https://www.youtube.com/watch?v=amvh4rzTCS0

After the configuration, keep your generated Incoming Webhook URL in a secret and secure way.

You will use it (the URL) in next sections of README.

### Hello World message sending

Once you have configured Incoming Webhook inside your Teams channels, you can send a very simple `Hello World` message:

```ruby
require 'microsoft_teams_incoming_webhook_ruby'

message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
  m.url  = 'YOUR INCOMING WEBHOOK URL HERE'
  m.text = 'Hello World!'
end

message.send
```

Note that there are 2 keys that is the minimum required to define a valid message for Teams:
 - `url`: The URL of Incoming Webhook connector, generated via Microsoft Teams
 - `text`: The text of your message

There are many other possible keys to be sent to Microsoft Incoming Webhook API.
But pay attention to always send **at least** the 2 keys.

# Gem public interface

The `MicrosoftTeamsIncomingWebhookRuby::Message` has 3 main methods:

- `new`: Initialization of object. You need to pass a block as parameters, containing the structure that will be converted automatically to JSON and be sent to Microsoft Incoming Webhook API.
- `builder`: Message builder object, that allows add/redefine/remove fields arbitrarily.
- `send`: Invocation of Incoming Webhook API, using HTTPS.

### Configuration of message structure lately of initialization

The message structure and its fields can be defined in two moments:

- Initialization of `MicrosoftTeamsIncomingWebhookRuby::Message` object
- After object initialization, but before `send` method call

🚨 You can add/remove any fields arbitrarily, but keeping at least the minimum required fields (`url` and `text`). Otherwise, an error will be generated when invoke `send` method.

Below that are some examples of this manipulation:

- Initialization of `MicrosoftTeamsIncomingWebhookRuby::Message` object

```ruby
require 'microsoft_teams_incoming_webhook_ruby'

message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
  m.url                        = 'YOUR INCOMING WEBHOOK URL HERE'
  m.text                       = 'Hello World!'

  m.my_arbitrary_field         = 'My value'
  m.my_another_arbitrary_field = { my: 'value' }
end

message.send
```

- Adding of attribute after object initialization, but before `send` method call

```ruby
require 'microsoft_teams_incoming_webhook_ruby'

message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
  m.url  = 'YOUR INCOMING WEBHOOK URL HERE'
  m.text = 'Hello World!'
end

message.builder.my_arbitrary_field         = 'My value'
message.builder.my_another_arbitrary_field = { my: 'value' }

message.send
```

- Removing of attributes after object initialization, but before `send` method call

```ruby
require 'microsoft_teams_incoming_webhook_ruby'

message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
  m.url                     = 'YOUR INCOMING WEBHOOK URL HERE'
  m.text                    = 'Hello World!'

  m.my_custom_field         = 'My custom value'
end

message.builder.delete_field :my_custom_field

message.send
```

- Redefing of attributes after object initialization, but before `send` method call

```ruby
require 'microsoft_teams_incoming_webhook_ruby'

message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
  m.url                     = 'YOUR INCOMING WEBHOOK URL HERE'
  m.text                    = 'Hello World!'

  m.my_custom_field         = 'My custom value'
end

message.builder.my_custom_field = 'Updated value'

message.send
```

### Error handling

You can build the message with any supported [card fields](https://docs.microsoft.com/en-us/outlook/actionable-messages/message-card-reference#card-fields).
This example is taken directly from [Microsoft Docs](https://docs.microsoft.com/en-us/outlook/actionable-messages/send-via-connectors)
```ruby
require "ms_teams"

message = MsTeams::Message.new do |m|
    m.url = "https://outlook.office.com/...."
    m.themeColor = "0072C6"
    m.title = "Visit the Outlook Dev Portal"
    m.text = "Click **Learn More** to learn more about Actionable Messages!"
    m.potentialAction = [
        {
            "@type": "ActionCard",
            "name": "Send Feedback",
            "inputs": [{
                "@type": "TextInput",
                "id": "feedback",
                "isMultiline": true,
                "title": "Let us know what you think about Actionable Messages"
            }],
            "actions": [{
                "@type": "HttpPOST",
                "name": "Send Feedback",
                "isPrimary": true,
                "target": "http://..."
            }]
        },
        {
            "@type": "OpenUri",
            "name": "Learn More",
            "targets": [
                { "os": "default", "uri": "https://docs.microsoft.com/outlook/actionable-messages" }
            ]
        }
    ]
end

# You can edit any field after the message has been built by modifying the `builder` object
message.builder.text = "Something new"

message.send
```

Error Handling:

A non-2xx response code will raise a `MsTeams::Message::FailedRequest` error

```ruby
# ...
begin
    message.send
rescue MsTeams::Message::FailedRequest => e
    # Do stuff
end
```


Building an invalid message object will immediately raise an error

```ruby
message = MsTeams::Message.new do |m|
    # no url set
    m.text = "Hello World"
end

> ArgumentError (`url` cannot be nil. Must be set during initialization)

```

## Execute tests/specs

To execute gem tests locally, use Docker with the commands below:

```bash
git clone https://github.com/pedrofurtado/microsoft_teams_incoming_webhook_ruby
cd microsoft_teams_incoming_webhook_ruby
docker build -t microsoft_teams_incoming_webhook_ruby_specs .

# Then, run this command how many times you want,
# after editing local files, and so on, to get
# feedback from test suite of gem.
docker run -v $(pwd):/app/ -it microsoft_teams_incoming_webhook_ruby_specs
```

## Demo

It's provided a simple demo app, in Heroku, that uses the gem always in latest commit. You can check and test your QRCodes here:

https://qrcode-pix-ruby.herokuapp.com

🚨 Important note: The first page load can be slow, because of Heroku free tier. But don't worry, the demo works well 🤓

## Execute demo locally

To execute demo locally, use Docker with the commands below:

```bash
git clone https://github.com/pedrofurtado/qrcode_pix_ruby
cd qrcode_pix_ruby/demo/
docker build -t qrcode_pix_ruby_demo .

# Then, access http://localhost:3000 the see demo in action.
docker run -p 3000:3000 -it qrcode_pix_ruby_demo
```

## Useful links

- ...
- ...

## Another similar gems for reference

There are similar open source libraries that shares the same purpose of this gem, such as:

- https://github.com/toririn/teams_incoming_clients
- https://github.com/shirts/microsoft-teams-ruby
- https://github.com/oooooooo/msteams-ruby-client
- https://github.com/eduardolagares/msteams_webhook

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pedrofurtado/microsoft_teams_incoming_webhook_ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/pedrofurtado/microsoft_teams_incoming_webhook_ruby/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the microsoft_teams_incoming_webhook_ruby project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/pedrofurtado/microsoft_teams_incoming_webhook_ruby/blob/master/CODE_OF_CONDUCT.md).
