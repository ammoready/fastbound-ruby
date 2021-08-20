require 'fastbound-ruby/api'

module FastBound
  class Client < Base

    include FastBound::API

    attr_accessor :account_number, :api_key

    def initialize(options = {})
      requires!(options, :account_number, :api_key)

      self.account_number = options[:account_number]
      self.api_key = options[:api_key]
    end

  end
end
