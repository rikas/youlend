# frozen_string_literal: true

require 'faraday'
require 'faraday_middleware'
require 'rainbow'
require 'addressable'

require 'youlend/path_sanitizer'
require 'youlend/response'

module Youlend
  class Connection
    BASE_PATH = '/'

    def with_token_refresh
      http_response = yield

      response = Response.new(http_response)

      # Try to get a valid token if the token has expired. This will also update the gem config
      # so we won't need to request the token again.
      if response.token_expired? || response.unauthorized?
        log "Refreshing outdated token... #{Youlend.configuration.token}"

        Auth.request_token

        http_response = yield
      end

      http_response
    end

    def post(path, params = {})
      log "POST: #{params.inspect}"
      http_response = with_token_refresh do
        adapter.post(PathSanitizer.sanitize(path), params.to_json)
      end

      Response.new(http_response)
    end

    private

    def log(text)
      return unless Youlend.configuration.debug?

      puts Rainbow("[Youlend] #{text}").magenta.bright
    end

    def base_url
      Addressable::URI.join(Youlend.configuration.api_domain, BASE_PATH).to_s
    end

    def adapter
      token = Youlend.configuration.token

      Faraday.new(url: base_url) do |conn|
        conn.headers['Authorization'] = "Bearer #{token}" unless token.to_s.empty?
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
