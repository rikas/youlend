# frozen_string_literal: true

# Following the API description here: https://staging.youlendapi.com/prequalification/index.html
module Youlend
  class Prequalification
    def self.verify(params)
      new(params).verify
    end

    def initialize(params)
      @params = params
    end

    def verify
      response = Youlend.connection.post('/prequalification/Requests', :prequalification, @params)

      # If there are errors in the data just return the response right away
      return response if response.status == 422

      # If we got back a response but all the funded amounts are 0.0 it means that the load was
      # actually rejected! We'll replace the response body with an error message instead and change
      # the success code.
      unless loan_accepted?(response.body)
        response.http_response.env.status = 422
        response.http_response.env.body = {
          error: 'Rejected',
          error_description: 'Loan was rejected'
        }
      end

      response
    end

    private

    def loan_accepted?(data)
      return false unless data[:loanOptions]

      options = data[:loanOptions]

      funded_amounts = options.map { |option| option[:fundedAmount] }

      funded_amounts.any?(&:positive?)
    end
  end
end
