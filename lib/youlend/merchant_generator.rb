# frozen_string_literal: true

require 'faker'

module Youlend
  class MerchantGenerator
    def self.generate(params = {})
      new(params).generate
    end


    def initialize(params = {})
      Faker::Config.locale = 'en-GB'

      generate
    end

    def generate
      {
        thirdPartyMerchantId: SecureRandom.uuid,
        companyName: 'HOKO LTD',
        companyNumber: '09525857',
        companyType: 'ltd',
        contactEmailAddress: 'oterosantos@gmail.com',
        countryISOCode: 'GBR',
        loanCurrencyISOCode: 'GBP',
        financialData: financial_data,
        significantPersons: [significant_person]
      }
    end

    private

    def financial_data
      {
        monthlyCardRevenue: 0,
        monthlyValueOfPurchaseTransactions: 0,
        monthlyRevenueFromInvoices: 0,
        paymentData: payment_data
      }
    end

    def payment_data
      (1..12).to_a.map do |month|
        {
          paymentDate: "#{Date.today.year - 1}-#{sprintf("%02d", month)}-01",
          amount: 5000,
          currencyISOCode: 'GBP'
        }
      end
    end

    def significant_person
      {
        firstName: Faker::Name.first_name,
        surname: Faker::Name.last_name,
        address: address,
        dateOfBirth: Date.parse('1980-01-01').to_s
      }
    end

    def address
      {
        line1: Faker::Address.street_address,
        line2: Faker::Address.secondary_address,
        city: 'London',
        region: 'London',
        areaCode: Faker::Address.zip_code,
        country: 'UK'
      }
    end
  end
end
