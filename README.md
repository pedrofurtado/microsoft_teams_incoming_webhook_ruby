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

This gems integrates your Ruby app to Microsoft Teams, though Incoming Webhook connector.

### Configuration of Incoming Webhook connector on your Teams channels

The first step before using the gem is to configure this connector inside your Team channels.

For this purpose, please check the official documentation from Microsoft. It's listed below some useful links:

- https://docs.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhook#create-incoming-webhook-1
- https://www.youtube.com/watch?v=amvh4rzTCS0

### Gem usage

Once you have Incoming webhook configured in Teams channels, you can execute a sample message (for test) with such code like this:

Example:
```ruby
require 'microsoft_teams_incoming_webhook_ruby'

message = MsTeams::Message.new do |m|
    m.url = "https://outlook.office.com/...."
    m.text = "Hello World!"
end

message.send
```

Note that there are 2 keys that is the minimum required to define a valid message:
 - `url`: The Incoming Webhook connector generated via Teams
 - `text`: The text of the message you are sending


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

...

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/microsoft_teams_incoming_webhook_ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/microsoft_teams_incoming_webhook_ruby/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the MicrosoftTeamsIncomingWebhookRuby project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/microsoft_teams_incoming_webhook_ruby/blob/master/CODE_OF_CONDUCT.md).
