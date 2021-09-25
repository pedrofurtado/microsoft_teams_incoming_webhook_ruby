# frozen_string_literal: true

RSpec.describe MicrosoftTeamsIncomingWebhookRuby do
  it 'has a valid version number' do
    version = MicrosoftTeamsIncomingWebhookRuby::VERSION
    expect(version).not_to be nil
    expect(version).to match(/^[0-9]+\.[0-9]+\.[0-9]+$/)
  end
end
