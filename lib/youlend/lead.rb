# frozen_string_literal: true

# Following the API description here: https://staging.youlend.com/developer/main/onboardingdoc
module Youlend
  class Lead
    def initialize(params)
      @id = nil
      @params = params
    end

    def create
      response = Youlend.connection.post('/onboarding/Leads', :onboarding, @params)
      response
    end

    def self.create(params)
      new(params).create
    end

    def self.details(lead_id)
      response = Youlend.connection.get("/onboarding/Leads/#{lead_id}/details", :onboarding)
    end
  end
end
