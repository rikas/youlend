# frozen_string_literal: true

# Following the API description here: https://staging.youlendapi.com/prequalification/index.html
module Youlend
  class Quote
    def self.pre_qualification(params)
      Youlend.connection.post('/prequalification/Requests', :prequalification, params)
    end
  end
end
