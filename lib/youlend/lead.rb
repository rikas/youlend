# frozen_string_literal: true

# Following the API description here: https://docs.youlend.com/reference/onboarding-intro
module Youlend
  class Lead
    def self.create(params)
      Youlend.connection.post('/onboarding/Leads', :onboarding, params)
    end

    def self.update(lead_id, params)
      Youlend.connection.put("/onboarding/Leads/#{lead_id}/organisationdetails", :onboarding, params)
    end

    def self.details(lead_id)
      Youlend.connection.get("/onboarding/Leads/#{lead_id}/details", :onboarding)
    end

    def self.offers(lead_id)
      Youlend.connection.get("/onboarding/Leads/#{lead_id}/offers", :onboarding)
    end

    def self.accept_offer(lead_id, offer_id)
      Youlend.connection.post("/onboarding/Leads/#{lead_id}/offers/#{offer_id}/acceptance", :onboarding)
    end

    def self.onboard_link(lead_id, email_address)
      domain = Youlend.configuration.domain

      url = Addressable::Template.new("#{domain}/dashboard/youlendapisignup{?query*}")
      url.expand(query: { emailAddress: email_address, leadId: lead_id }).to_s
    end
  end
end
