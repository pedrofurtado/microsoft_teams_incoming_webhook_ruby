# frozen_string_literal: true

require 'bundler/setup'
require 'microsoft_teams_incoming_webhook_ruby'
require 'webmock/rspec'

WebMock.disable_net_connect!

if !ENV['CODECOV_TOKEN'].nil? && !ENV['CODECOV_TOKEN'].empty?
  require 'simplecov'
  SimpleCov.start
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

RSpec.configure do |config|
  config.example_status_persistence_file_path = '.rspec_status'
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
