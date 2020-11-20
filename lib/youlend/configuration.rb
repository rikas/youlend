# frozen_string_literal: true

module Youlend
  class Configuration
    attr_accessor :token, :client_id, :client_secret, :env
    attr_writer :debug

    API_DOMAINS = {
      production: '',
      development: 'https://staging.youlendapi.com'
    }.freeze

    #https://staging.youlendapi.com/prequalification/index.html

    def initialize
      @token = ''
      @webhook_signature = ''
      @env = defined?(Rails) ? Rails.env : :development
      @debug = false
    end

    def debug?
      @debug
    end

    def api_domain
      API_DOMAINS[@env.to_sym] || API_DOMAINS[:development]
    end
  end
end
