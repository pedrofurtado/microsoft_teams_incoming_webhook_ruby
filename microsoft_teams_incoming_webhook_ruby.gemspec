# frozen_string_literal: true

require_relative 'lib/microsoft_teams_incoming_webhook_ruby/version'

Gem::Specification.new do |spec|
  spec.name                        = 'microsoft_teams_incoming_webhook_ruby'
  spec.version                     = MicrosoftTeamsIncomingWebhookRuby::VERSION
  spec.authors                     = ['Pedro Furtado']
  spec.email                       = ['pedro.felipe.azevedo.furtado@gmail.com']
  spec.summary                     = 'Ruby gem for integration with Microsoft Teams Incoming Webhook'
  spec.description                 = 'Ruby gem for integration with Microsoft Teams Incoming Webhook'
  spec.homepage                    = 'https://github.com/pedrofurtado/microsoft_teams_incoming_webhook_ruby'
  spec.license                     = 'MIT'
  spec.required_ruby_version       = Gem::Requirement.new('>= 2.3.0')
  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"]   = "#{spec.homepage}/CHANGELOG.md"

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end

  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
