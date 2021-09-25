# frozen_string_literal: true

require 'net/http'
require 'json'
require 'openssl'

module MicrosoftTeamsIncomingWebhookRuby
  class Message
    module Error
      class GenericError   < StandardError; end
      class InvalidMessage < GenericError; end
      class FailedRequest  < GenericError; end
    end

    attr_reader :builder

    def initialize(&block)
      @builder = OpenStruct.new
      yield @builder
      validate_builder
    end

    def send
      validate_builder
      response = send_by_http
      check_failure_for(response)
      response
    end

    private

    REQUIRED_FIELDS = ['url', 'text']

    def validate_builder
      REQUIRED_FIELDS.each do |field|
        raise_error_on(field) if @builder[field].nil? || @builder[field].empty?
      end
    end

    def raise_error_on(field)
      raise Error::InvalidMessage, "'#{field}' must be defined in Message"
    end

    def send_by_http
      uri              = URI.parse(@builder.url)
      http             = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl     = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      http.post(uri.path, @builder.to_h.to_json, 'Content-Type': 'application/json')
    end

    def check_failure_for(response)
      raise Error::FailedRequest, "The message failed to be sent (HTTP Code #{response.code})" unless success?(response)
    end

    def success?(http_response)
      http_code = http_response&.code&.to_i
      http_code_2xx = http_code >= 200 && http_code <= 299
      http_code_3xx = http_code >= 300 && http_code <= 399
      http_code_2xx || http_code_3xx
    end
  end
end
