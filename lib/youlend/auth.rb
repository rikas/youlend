# frozen_string_literal: true

require 'multi_json'
require 'faraday'
require 'faraday_middleware'
require 'addressable'

module Youlend
  class Auth
    extend Forwardable

    AUTH_URLS = {
      production: 'https://youlend.eu.auth0.com',
      development: 'https://youlend-stag.eu.auth0.com'
    }.freeze

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
        audience: "#{Youlend.configuration.api_domain}/#{audience}"
      }

      result = adapter.post('/oauth/token', params.to_json)

      json = result.body

      raise json[:error_description] if json[:error]

      @configuration.tokens[audience] = json[:access_token] unless json[:error]
    end

    private

    def adapter
      auth_url = AUTH_URLS[Youlend.configuration.env]

      Faraday.new(url: auth_url) do |conn|
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
