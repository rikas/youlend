# frozen_string_literal: true

require 'multi_json'
require 'faraday'
require 'faraday_middleware'
require 'addressable'

module Youlend
  class Auth
    extend Forwardable

    AUTH_URL = 'https://youlend-stag.eu.auth0.com'

    def_delegators :@configuration, :client_id, :client_secret

    def initialize(access_type: nil, scopes: nil)
      @configuration = Youlend.configuration
    end

    def self.request_token
      new.request_token
    end

    def request_token
      params = {
        grant_type: 'client_credentials',
        client_id: client_id,
        client_secret: client_secret,
        audience: 'https://staging.youlendapi.com/prequalification'
      }

      result = adapter.post('/oauth/token', params.to_json)

      json = result.body

      @configuration.token = json[:access_token] if !json[:error]
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
