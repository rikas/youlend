# frozen_string_literal: true

require 'faker'

module Youlend
  class MerchantGenerator
    def self.generate
      new.generate
    end

    def initialize
      Faker::Config.locale = 'en-GB'

      generate
    end

    # Mandatory fields:
    # * CompanyName
    # * CompanyType (ltd, plc, llp, dac, partnership, soleTrader, aps, as, ks, ivs and is)
    # * CompanyNumber
    # * FinancialData
    # * CountryISOCode (GBR, DNK and IRE)
    # * LoanCurrencyISOCode (ISO 4217 currency code. Valid codes are GBP, EUR and DKK)
    # * ThirdPartyMerchantId
    def generate
      {
        companyName: 'HOKO LTD',
        companyType: 'ltd',
        companyNumber: '09525857',
        financialData: financial_data,
        countryISOCode: 'GBR',
        loanCurrencyISOCode: 'GBP',
        thirdPartyMerchantId: SecureRandom.uuid,
        significantPersons: [significant_person],     # optional
        contactEmailAddress: 'oterosantos@gmail.com'  # optional
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
        formatted_month = format('%02<month>d', month: month)

        {
          paymentDate: "#{Date.today.year - 1}-#{formatted_month}-01",
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
