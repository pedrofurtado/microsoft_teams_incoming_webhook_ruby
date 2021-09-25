# frozen_string_literal: true

RSpec.describe MicrosoftTeamsIncomingWebhookRuby do
  it 'has a valid version number' do
    version = MicrosoftTeamsIncomingWebhookRuby::VERSION
    expect(version).not_to be nil
    expect(version).to match(/^[0-9]+\.[0-9]+\.[0-9]+$/)
  end
end

RSpec.describe MicrosoftTeamsIncomingWebhookRuby::Message do
  context '#initialize' do
    it 'constructs an OpenStruct object from the given block' do
      message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
        m.url             = 'https://example.com'
        m.title           = 'Hello World'
        m.text            = '1 2 3'
        m.arbitrary_field = 'An arbitrary field'
      end

      expect(message).to_not be_nil
      expect(message.builder).to_not be_nil
      expect(message.builder).to be_a(OpenStruct)
      expect(message.builder.url).to eq('https://example.com')
      expect(message.builder.title).to eq('Hello World')
      expect(message.builder.text).to eq('1 2 3')
      expect(message.builder.arbitrary_field).to eq('An arbitrary field')
    end

    it 'requires a block to be initialized' do
      expect { MicrosoftTeamsIncomingWebhookRuby::Message.new }.to raise_error(LocalJumpError)
    end

    it 'raises an InvalidMessage when the builder object is initialized without a url property' do
      error_message = "'url' must be defined in Message"

      expect do
        MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
          m.url  = nil
          m.text = '1 2 3'
        end
      end.to raise_error(MicrosoftTeamsIncomingWebhookRuby::Message::Error::InvalidMessage, error_message)

      expect do
        MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
          m.url = ''
          m.text = '1 2 3'
        end
      end.to raise_error(MicrosoftTeamsIncomingWebhookRuby::Message::Error::InvalidMessage, error_message)

      expect do
        MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
          m.text = '1 2 3'
        end
      end.to raise_error(MicrosoftTeamsIncomingWebhookRuby::Message::Error::InvalidMessage, error_message)
    end

    it 'raises an InvalidMessage when the `builder` object is initialized without a text property' do
      error_message = "'text' must be defined in Message"

      expect do
        MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
          m.url = 'https://example.com'
          m.text = nil
        end
      end.to raise_error(MicrosoftTeamsIncomingWebhookRuby::Message::Error::InvalidMessage, error_message)

      expect do
        MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
          m.url = 'https://example.com'
          m.text = ''
        end
      end.to raise_error(MicrosoftTeamsIncomingWebhookRuby::Message::Error::InvalidMessage, error_message)

      expect do
        MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
          m.url = 'https://example.com'
        end
      end.to raise_error(MicrosoftTeamsIncomingWebhookRuby::Message::Error::InvalidMessage, error_message)
    end
  end

  context '#send' do
    context 'with a valid builder object' do
      it 'returns Net::HTTPOK' do
        [200, 300].each do |successful_http_code|
          message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
            m.url = 'https://example.com/example'
            m.text = '1 2 3'
          end

          stub_request(:post, 'https://example.com/example').with(
            headers: {
              'Accept': '*/*',
              'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type': 'application/json',
              'User-Agent': 'Ruby'
            },
            body: {
              'url': 'https://example.com/example',
              'text': '1 2 3'
            }
          ).to_return(status: successful_http_code, body: '', headers: {})

          expect(message.send.response.code.to_i).to eq(successful_http_code)
        end
      end

      it 'returns FailedRequest if any error occurs' do
        [100, 400, 500].each do |non_successful_http_code|
          message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
            m.url = 'https://example.com/example'
            m.text = '1 2 3'
          end

          stub_request(:post, 'https://example.com/example').with(
            headers: {
              'Accept': '*/*',
              'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
              'Content-Type': 'application/json',
              'User-Agent': 'Ruby'
            },
            body: {
              'url': 'https://example.com/example',
              'text': '1 2 3'
            }
          ).to_return(status: non_successful_http_code, body: '', headers: {})

          expect { message.send }.to raise_error(MicrosoftTeamsIncomingWebhookRuby::Message::Error::FailedRequest)
        end
      end
    end

    context 'with an invalid builder object' do
      it 'does raise an error without a set url property' do
        message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
          m.url = 'https://example.com'
          m.text = '1 2 3'
        end
        message.builder.delete_field(:url)
        expect { message.send }.to raise_error(MicrosoftTeamsIncomingWebhookRuby::Message::Error::InvalidMessage)

        message_2 = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
          m.url = 'https://example.com'
          m.text = '1 2 3'
        end
        message_2.builder.url = ''
        expect { message_2.send }.to raise_error(MicrosoftTeamsIncomingWebhookRuby::Message::Error::InvalidMessage)

        message_3 = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
          m.url = 'https://example.com'
          m.text = '1 2 3'
        end
        message_3.builder.url = nil
        expect { message_3.send }.to raise_error(MicrosoftTeamsIncomingWebhookRuby::Message::Error::InvalidMessage)
      end

      it 'does raise an error without a set text property' do
        message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
          m.url = 'https://example.com'
          m.text = '1 2 3'
        end
        message.builder.delete_field(:text)
        expect { message.send }.to raise_error(MicrosoftTeamsIncomingWebhookRuby::Message::Error::InvalidMessage)

        message_2 = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
          m.url = 'https://example.com'
          m.text = '1 2 3'
        end
        message_2.builder.text = ''
        expect { message_2.send }.to raise_error(MicrosoftTeamsIncomingWebhookRuby::Message::Error::InvalidMessage)

        message_3 = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
          m.url = 'https://example.com'
          m.text = '1 2 3'
        end
        message_3.builder.text = nil
        expect { message_3.send }.to raise_error(MicrosoftTeamsIncomingWebhookRuby::Message::Error::InvalidMessage)
      end
    end
  end

  context '#builder' do
    it 'cannot be redefined itself' do
      message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
        m.url             = 'https://example.com'
        m.title           = 'Hello World'
        m.text            = '1 2 3'
        m.arbitrary_field = 'An arbitrary field'
      end

      expect { message.builder = nil }.to raise_error(NoMethodError)
      expect { message.builder = '' }.to raise_error(NoMethodError)
      expect { message.builder = OpenStruct.new }.to raise_error(NoMethodError)
    end

    it 'can redefine properties lately' do
      message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
        m.url             = 'https://example.com'
        m.title           = 'Hello World'
        m.text            = '1 2 3'
        m.arbitrary_field = 'An arbitrary field'
      end

      expect(message.builder.arbitrary_field).to eq 'An arbitrary field'

      message.builder.arbitrary_field = 'Another value for arbitrary field'

      expect(message.builder.arbitrary_field).to eq 'Another value for arbitrary field'
    end

    it 'can add properties lately' do
      message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
        m.url             = 'https://example.com'
        m.title           = 'Hello World'
        m.text            = '1 2 3'
        m.arbitrary_field = 'An arbitrary field'
      end

      expect(message.builder.respond_to?(:another_field)).to eq false
      expect(message.builder.another_field).to eq nil

      message.builder.another_field = 'Another new field'

      expect(message.builder.respond_to?(:another_field)).to eq true
      expect(message.builder.another_field).to eq 'Another new field'
    end

    it 'can remove properties lately' do
      message = MicrosoftTeamsIncomingWebhookRuby::Message.new do |m|
        m.url             = 'https://example.com'
        m.title           = 'Hello World'
        m.text            = '1 2 3'
        m.arbitrary_field = 'An arbitrary field'
      end

      expect(message.builder.respond_to?(:arbitrary_field)).to eq true
      expect(message.builder.arbitrary_field).to eq 'An arbitrary field'

      message.builder.delete_field :arbitrary_field

      expect(message.builder.respond_to?(:arbitrary_field)).to eq false
      expect(message.builder.arbitrary_field).to eq nil
    end
  end
end

RSpec.describe MicrosoftTeamsIncomingWebhookRuby::Message::Error do
  context 'InvalidMessage' do
    it 'inherits from GenericError' do
      expect(MicrosoftTeamsIncomingWebhookRuby::Message::Error::InvalidMessage).to be < MicrosoftTeamsIncomingWebhookRuby::Message::Error::GenericError
    end
  end

  context 'FailedRequest' do
    it 'inherits from GenericError' do
      expect(MicrosoftTeamsIncomingWebhookRuby::Message::Error::FailedRequest).to be < MicrosoftTeamsIncomingWebhookRuby::Message::Error::GenericError
    end
  end

  context 'GenericError' do
    it 'inherits from StandardError' do
      expect(MicrosoftTeamsIncomingWebhookRuby::Message::Error::GenericError).to be < StandardError
    end
  end
end
