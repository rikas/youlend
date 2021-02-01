# frozen_string_literal: true

module Youlend
  class Configuration
    attr_accessor :tokens, :client_id, :client_secret, :env
    attr_writer :debug

    API_DOMAINS = {
      production: '',
      development: 'https://staging.youlendapi.com'
    }.freeze

    def initialize
      @tokens = { onboarding: '', prequalification: '' }
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
