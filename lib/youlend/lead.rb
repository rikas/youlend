# frozen_string_literal: true

# Following the API description here: https://staging.youlend.com/developer/main/onboardingdoc
module Youlend
  class Lead
    def initialize(params)
      @id = nil
      @params = params
    end

    def create
      Youlend.connection.post('/onboarding/Leads', :onboarding, @params)
    end

    def self.create(params)
      new(params).create
    end

    def self.details(lead_id)
      Youlend.connection.get("/onboarding/Leads/#{lead_id}/details", :onboarding)
    end
  end
end
