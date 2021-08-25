require 'fastbound-ruby/api'
require 'fastbound-ruby/account'
require 'fastbound-ruby/item'

module FastBound
  class Client < Base

    include FastBound::API

    attr_accessor :account_number, :api_key

    def initialize(options = {})
      requires!(options, :account_number, :api_key)

      self.account_number = options[:account_number]
      self.api_key = options[:api_key]
    end

    def account
      @account ||= FastBound::Account.new(self)
    end

    def item
      @item ||= FastBound::Item.new(self)
    end

  end
end
