# frozen_string_literal: true

module Youlend
  class Quote
    def self.pre_qualification(params)
      Youlend.connection.post('/prequalification/Requests', params)
    end
  end
end
