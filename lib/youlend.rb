# frozen_string_literal: true

require 'youlend/version'
require 'youlend/auth'
require 'youlend/configuration'
require 'youlend/connection'
require 'youlend/quote'

module Youlend
  module_function

  def configuration
    @configuration ||= Configuration.new
  end

  def connection
    @connection ||= Connection.new
  end

  def configure
    yield(configuration)
  end
end
