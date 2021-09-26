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

The first step before using this gem is to configure the connector inside your Teams channels.

For this purpose, please check the official documentation from Microsoft. It's listed below some useful links:

- https://docs.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/add-incoming-webhook
- https://techcommunity.microsoft.com/t5/microsoft-365-pnp-blog/how-to-configure-and-use-incoming-webhooks-in-microsoft-teams/ba-p/2051118
- https://www.youtube.com/watch?v=amvh4rzTCS0

After the configuration, keep your generated Incoming Webhook URL in a secret and secure way.

You will use it (the URL) in next sections of README.

### Hello World message sending

Once you have configured Incoming Webhook inside your Teams channels, you can send a very simple `Hello World` message:

```ruby
require 'microsoft_teams_incoming_webhook_ruby'

message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
  m.url = 'YOUR INCOMING WEBHOOK URL HERE'
  m.text = 'Hello World!'
end

message.send
```

Note that there are 2 keys that is the minimum required to define a valid message for Teams:
 - `url`: The URL of Incoming Webhook connector, generated via Microsoft Teams
 - `text`: The text of your message

There are many other possible keys to be sent to Microsoft Incoming Webhook API.
But pay attention to always send **at least** the 2 keys.

### Gem public interface

The `MicrosoftTeamsIncomingWebhookRuby::Message` class has 3 main methods:

- `new`: Initialization of object. You need to pass a block as parameter, containing the message structure. This structure will be converted automatically to JSON and be sent to Microsoft Incoming Webhook API.
- `builder`: Message builder object, that allows add/redefine/remove fields arbitrarily.
- `send`: Invocation of Incoming Webhook API, using HTTPS.

### Message structure

The Microsoft Incoming Webhook API allows us to send a variety of fields, that will result in diferents cards displayed in Teams channels.

Because of this, the gem will not enforce any schema in message structure. The only required parameters are `url` and `text`. Any other options will be accepted, considering that Microsoft Incoming Webhook API accepts it.

The message structure and its fields can be defined in two moments:

- Initialization of `MicrosoftTeamsIncomingWebhookRuby::Message` object
- After object initialization, but before `send` method call

🚨 You can add/replace/remove any fields arbitrarily, but keeping at least the minimum required fields (`url` and `text`). Otherwise, an error will be generated when invoke `send` method.

Below there are some examples of this manipulation:

- Initialization of attributes in `MicrosoftTeamsIncomingWebhookRuby::Message` object

```ruby
require 'microsoft_teams_incoming_webhook_ruby'

message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
  m.url = 'YOUR INCOMING WEBHOOK URL HERE'
  m.text = 'Hello World!'
  m.my_arbitrary_field = 'My value'
  m.my_another_arbitrary_field = { my: 'value' }
end

message.send
```

- Addition of attribute after object initialization, but before `send` method call

```ruby
require 'microsoft_teams_incoming_webhook_ruby'

message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
  m.url = 'YOUR INCOMING WEBHOOK URL HERE'
  m.text = 'Hello World!'
end

message.builder.my_arbitrary_field = 'My value'
message.builder.my_another_arbitrary_field = { my: 'value' }

message.send
```

- Remotion of attributes after object initialization, but before `send` method call

```ruby
require 'microsoft_teams_incoming_webhook_ruby'

message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
  m.url = 'YOUR INCOMING WEBHOOK URL HERE'
  m.text = 'Hello World!'
  m.my_custom_field = 'My custom value'
end

message.builder.delete_field :my_custom_field

message.send
```

- Redefinition of attributes after object initialization, but before `send` method call

```ruby
require 'microsoft_teams_incoming_webhook_ruby'

message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
  m.url = 'YOUR INCOMING WEBHOOK URL HERE'
  m.text = 'Hello World!'
  m.my_custom_field = 'My custom value'
end

message.builder.my_custom_field = 'Updated value'

message.send
```

In case of keys that starts with **@**, it is necessary to use brackets notation:

```ruby
require 'microsoft_teams_incoming_webhook_ruby'

message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
  m.url = 'YOUR INCOMING WEBHOOK URL HERE'
  m.text = 'Hello World!'
  m['@my_field'] = 'Lorem ipsum'
end

message.builder['@my_another_new_field'] = 'Ipsum valorium'

message.send
```

### Error handling

If the builder object turn itself invalid before invocation of `send` method, the gem will raise a `MicrosoftTeamsIncomingWebhookRuby::Message::Error::InvalidMessage` exception:

```ruby
require 'microsoft_teams_incoming_webhook_ruby'

message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
  m.url = 'YOUR INCOMING WEBHOOK URL HERE'
  m.text = 'Hello World!'
end

message.builder.delete_field :url

begin
  message.send
rescue MicrosoftTeamsIncomingWebhookRuby::Message::Error::InvalidMessage
  puts 'Your message structure is invalid!'
end
```

```ruby
require 'microsoft_teams_incoming_webhook_ruby'

begin
  message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
    m.my_only_one_field = 'Lorem ipsum'
  end
rescue MicrosoftTeamsIncomingWebhookRuby::Message::Error::InvalidMessage
  puts 'Your message structure is invalid'
end
```

If a non-successful response code be returned by API (1xx, 4xx or 5xx), the gem will raise a `MicrosoftTeamsIncomingWebhookRuby::Message::Error::FailedRequest` exception:

```ruby
require 'microsoft_teams_incoming_webhook_ruby'

message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
  m.url = 'YOUR INCOMING WEBHOOK URL HERE'
  m.text = 'My message'
end

begin
  message.send
rescue MicrosoftTeamsIncomingWebhookRuby::Message::Error::FailedRequest
  puts 'Microsoft API is down, broken, or your network failed!'
end
```

## Examples

You can build and send messages with any supported card fields provided by Microsoft:

- https://docs.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/how-to/connectors-using
- https://adaptivecards.io/samples
- https://docs.microsoft.com/en-us/outlook/actionable-messages/message-card-reference
- https://amdesigner.azurewebsites.net
- https://messagecardplayground.azurewebsites.net
- https://docs.microsoft.com/en-us/outlook/actionable-messages/adaptive-card
- https://docs.microsoft.com/en-us/microsoftteams/platform/webhooks-and-connectors/what-are-webhooks-and-connectors

We will provide below some ready-to-go examples to be used, based on API described in links above.

### Minimal

```ruby
require 'microsoft_teams_incoming_webhook_ruby'

webhook_url = 'YOUR INCOMING WEBHOOK URL HERE'

message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
  m.url = webhook_url
  m.text = 'Minimal message!'
end

message.send
```

### Theme color

```ruby
require 'microsoft_teams_incoming_webhook_ruby'

webhook_url = 'YOUR INCOMING WEBHOOK URL HERE'

message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
  m.url = webhook_url
  m.text = 'Message with theme color!'
  m.themeColor = 'FF0000'
end

message.send
```

### Title

```ruby
require 'microsoft_teams_incoming_webhook_ruby'

webhook_url = 'YOUR INCOMING WEBHOOK URL HERE'

message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
  m.url = webhook_url
  m.text = 'Message with title!'
  m.title = 'My title'
end

message.send
```

### Summary

```ruby
require 'microsoft_teams_incoming_webhook_ruby'

webhook_url = 'YOUR INCOMING WEBHOOK URL HERE'

message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
  m.url = webhook_url
  m.text = 'Message with summary!'
  m.summary = 'My summary'
end

message.send
```

### Potential action

```ruby
require 'microsoft_teams_incoming_webhook_ruby'

webhook_url = 'YOUR INCOMING WEBHOOK URL HERE'

message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
  m.url = webhook_url
  m.text = 'Message with potential action!'
  m.potentialAction = [
    {
      '@type': 'ActionCard',
      'name': 'Answer',
      'inputs': [
        {
          '@type': 'TextInput',
          'id': 'title',
          'isMultiline': true,
          'title': 'Your text here'
        }
      ],
      'actions': [
        {
          '@type': 'HttpPOST',
          'name': 'Send my answer',
          'isPrimary': true,
          'target': 'https://example.com/example'
        }
      ]
    },
    {
      '@type': 'HttpPOST',
      'name': 'Make another action',
      'target': 'https://example.com/example2'
    },
    {
      '@type': 'OpenUri',
      'name': 'Open a URL',
      'targets': [
        {
          'os': 'default',
          'uri': 'https://github.com/pedrofurtado/microsoft_teams_incoming_webhook_ruby'
        }
      ]
    }
  ]
end

message.send
```

### Sections

```ruby
require 'microsoft_teams_incoming_webhook_ruby'

webhook_url = 'YOUR INCOMING WEBHOOK URL HERE'

message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
  m.url = webhook_url
  m.text = 'Message with sections!'
  m.sections = [
    {
      'text': 'Lorem ipsum vastium',
      'activityTitle': 'John Smith',
      'activitySubtitle': '01/01/1990, 11:45AM',
      'activityImage': 'https://connectorsdemo.azurewebsites.net/images/MSC12_Oscar_002.jpg',
      'facts': [
        { 'name': 'Repository:', 'value': 'my-repo' },
        { 'name': 'Issue #:',    'value': '123456789' }
      ]
    }
  ]
end

message.send
```

### Advanced

```ruby
require 'microsoft_teams_incoming_webhook_ruby'

webhook_url = 'YOUR INCOMING WEBHOOK URL HERE'

message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
  m.url = webhook_url
  m.text = 'Advanced message'
  m['@type'] = 'MessageCard'
  m['@context'] = 'http://schema.org/extensions'
  m.themeColor = '0076D7'
  m.summary = 'Larry Bryant created a new task'

  m.sections = [
    {
      'activityTitle': 'Larry Bryant created a new task',
      'activitySubtitle': 'On Project Tango',
      'activityImage': 'https://teamsnodesample.azurewebsites.net/static/img/image5.png',
      'markdown': true,
      'facts': [
        { 'name': 'Assigned to', 'value': 'Unassigned' },
        { 'name': 'Due date', 'value': 'Mon May 01 2017 17:07:18 GMT-0700 (Pacific Daylight Time)' },
        { 'name': 'Status', 'value': 'Not started' }
      ]
    }
  ]

  m.potentialAction = [
    {
      '@type': 'ActionCard',
      'name': 'Add a comment',
      'inputs': [
        {
          '@type': 'TextInput',
          'id': 'comment',
          'isMultiline': false,
          'title': 'Add a comment here for this task'
        }
      ],
      'actions': [
        {
          '@type': 'HttpPOST',
          'name': 'Add comment',
          'target': 'https://docs.microsoft.com/outlook/actionable-messages'
        }
      ]
    },
    {
      '@type': 'ActionCard',
      'name': 'Set due date',
      'inputs': [
        {
          '@type': 'DateInput',
          'id': 'dueDate',
          'title': 'Enter a due date for this task'
        }
      ],
      'actions': [
        {
          '@type': 'HttpPOST',
          'name': 'Save',
          'target': 'https://docs.microsoft.com/outlook/actionable-messages'
        }
      ]
    },
    {
      '@type': 'OpenUri',
      'name': 'Learn More',
      'targets': [
        {
          'os': 'default',
          'uri': 'https://docs.microsoft.com/outlook/actionable-messages'
        }
      ]
    },
    {
      '@type': 'ActionCard',
      'name': 'Change status',
      'inputs': [
        {
          '@type': 'MultichoiceInput',
          'id': 'list',
          'title': 'Select a status',
          'isMultiSelect': 'false',
          'choices': [
            { 'display': 'In Progress', 'value': '1' },
            { 'display': 'Active',      'value': '2' },
            { 'display': 'Closed',      'value': '3' }
          ]
        }
      ],
      'actions': [
        {
          '@type': 'HttpPOST',
          'name': 'Save',
          'target': 'https://docs.microsoft.com/outlook/actionable-messages'
        }
      ]
    }
  ]
end

message.send
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

## Similar gems for reference

There are similar and great open source libraries that shares the same purpose of this gem, such as:

- https://github.com/toririn/teams_incoming_clients
- https://github.com/shirts/microsoft-teams-ruby
- https://github.com/oooooooo/msteams-ruby-client
- https://github.com/eduardolagares/msteams_webhook
- https://github.com/adventistmedia/msteams_notifier

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pedrofurtado/microsoft_teams_incoming_webhook_ruby. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/pedrofurtado/microsoft_teams_incoming_webhook_ruby/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the microsoft_teams_incoming_webhook_ruby project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/pedrofurtado/microsoft_teams_incoming_webhook_ruby/blob/master/CODE_OF_CONDUCT.md).
