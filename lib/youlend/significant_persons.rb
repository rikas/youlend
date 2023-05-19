module Youlend
  class SignificantPersons
    def self.create(lead_id, params)
      new(lead_id).create(params)
    end

    def initialize(lead_id)
      @lead_id = lead_id
    end

    def create(params)
      Youlend.connection.put("/onboarding/Leads/#{@lead_id}/significantpersons", :onboarding, params)
    end
  end
end
