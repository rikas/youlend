# frozen_string_literal: true

require 'faker'

module Youlend
  module ParamsGenerators
    class Lead
      def self.generate
        new.generate
      end

      def initialize
        Faker::Config.locale = 'en-GB'

        generate
      end

      # Mandatory fields:
      # * CompanyName
      # * CompanyType (ltd, plc, llp, dac, soleTrader, aps, as, ks, ivs and is)
      # * MonthsTrading
      # * CountryISOCode (GBR, DNK and IRE)
      # * KeyContactName
      # * ThirdPartyLeadId
      # * RegisteredAddress
      # * ContactPhoneNumber
      # * MonthlyCardRevenue (must be greater than or equal to '1000')
      # * ContactEmailAddress
      # * LoanCurrencyISOCode (ISO 4217 currency code. Valid codes are GBP, EUR and DKK)
      # * ThirdPartyCustomerId
      def generate
        {
          companyName: 'HOKO LTD',
          companyType: 'ltd',
          monthsTrading: rand(3..10),
          countryISOCode: 'GBR',
          country: 'GBR',
          keyContactName: Faker::Name.name,
          thirdPartyLeadId: SecureRandom.uuid,
          registeredAddress: address,
          contactPhoneNumber: Faker::PhoneNumber.phone_number,
          # monthlyCardRevenue: 10_000,
          contactEmailAddress: Faker::Internet.email,
          loanCurrencyISOCode: 'GBP',
          thirdPartyCustomerId: SecureRandom.uuid,
          description: 'desc',
          companyNumber: '09525857',                # optional
          notificationURL: Faker::Internet.url,     # optional
          thirdPartyMerchantId: SecureRandom.uuid   # optional
        }
      end

      private

      def address
        {
          line1: Faker::Address.street_address,
          line2: Faker::Address.secondary_address,
          city: 'London',
          region: 'London',
          areaCode: Faker::Address.zip_code,
          country: 'GBR'
        }
      end
    end
  end
end
