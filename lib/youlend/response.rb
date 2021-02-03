# frozen_string_literal: true

require 'forwardable'

module Youlend
  class Response
    extend Forwardable

    attr_reader :http_response
    def_delegators :@http_response, :headers, :body, :status, :success?

    def initialize(http_response)
      @http_response = http_response
    end

    def unauthorized?
      status == 401
    end

    def token_expired?
      auth_header = @http_response.headers['www-authenticate']

      return false unless auth_header

      auth_header.match?(/.*token is expired.*/)
    end
  end
end
