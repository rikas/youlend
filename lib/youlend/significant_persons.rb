# frozen_string_literal: true

module Youlend
  class SignificantPersons
    def self.create(lead_id, params)
      Youlend.connection.put("/onboarding/Leads/#{lead_id}/significantpersons", :onboarding, params)
    end
  end
end
