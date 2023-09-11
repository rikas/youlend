# frozen_string_literal: true

require 'faker'

module Youlend
  module ParamsGenerators
    class SignificantPersons
      def self.generate
        new.generate
      end

      def generate
        {
          significantPersons: [
            {
              typeOfPerson: 'Director',
              address: {
                line1: Faker::Address.street_address,
                line2: Faker::Address.secondary_address,
                city: 'London',
                region: 'London',
                areaCode: Faker::Address.zip_code,
                country: 'GBR'
              },
              dateOfBirth: {
                year: 2000,
                month: 1,
                day: 1
              },
              firstName: Faker::Name.first_name,
              surname: Faker::Name.last_name,
              emailAddress: Faker::Internet.email,
              mobilePhoneNumber: Faker::PhoneNumber.phone_number,
              percentageOwned: rand(10..80),
              nationality: Faker::Nation.nationality
            }
          ]
        }
      end
    end
  end
end
