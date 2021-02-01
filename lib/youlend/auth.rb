# frozen_string_literal: true

require 'multi_json'
require 'faraday'
require 'faraday_middleware'
require 'addressable'

module Youlend
  class Auth
    extend Forwardable

    AUTH_URL = 'https://youlend-stag.eu.auth0.com'
    AUDIENCE_URL = 'https://staging.youlendapi.com/'

    AUDIENCES = %i[prequalification onboarding].freeze
    DEFAULT_AUDIENCE = :prequalification

    def_delegators :@configuration, :client_id, :client_secret

    def initialize
      @configuration = Youlend.configuration
    end

    def self.request_token(audience = DEFAULT_AUDIENCE)
      new.request_token(audience)
    end

    def request_token(audience = DEFAULT_AUDIENCE)
      raise 'Invalid Audience' unless AUDIENCES.include?(audience.to_sym)

      params = {
        grant_type: 'client_credentials',
        client_id: client_id,
        client_secret: client_secret,
        audience: "#{AUDIENCE_URL}#{audience}"
      }

      result = adapter.post('/oauth/token', params.to_json)

      json = result.body

      @configuration.tokens[audience] = json[:access_token] unless json[:error]
    end

    def adapter
      Faraday.new(url: AUTH_URL) do |conn|
        conn.headers['Content-Type'] = 'application/json'
        conn.headers['User-Agent'] = "ruby-youlend-#{VERSION}"
        conn.use FaradayMiddleware::ParseJson
        conn.response :json, parser_options: { symbolize_names: true }
        conn.response :logger if Youlend.configuration.debug?
        conn.adapter Faraday.default_adapter
      end
    end
  end
end
