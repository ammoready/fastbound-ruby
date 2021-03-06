require 'fastbound-ruby/api'
require 'fastbound-ruby/account'
require 'fastbound-ruby/acquisition'
require 'fastbound-ruby/attachment'
require 'fastbound-ruby/contact'
require 'fastbound-ruby/disposition'
require 'fastbound-ruby/item'
require 'fastbound-ruby/smart_list'
require 'fastbound-ruby/webhook'

module FastBound
  class Client < Base

    include FastBound::API

    attr_accessor :account_number, :api_key, :account_email

    def initialize(options = {})
      requires!(options, :account_number, :api_key, :account_email)

      self.account_number = options[:account_number]
      self.api_key = options[:api_key]
      self.account_email = options[:account_email]
    end

    def account
      @account ||= FastBound::Account.new(self)
    end

    def acquisition
      @acquisition ||= FastBound::Acquisition.new(self)
    end

    def attachment
      @attachment ||= FastBound::Attachment.new(self)
    end

    def contact
      @contact ||= FastBound::Contact.new(self)
    end

    def disposition
      @disposition ||= FastBound::Disposition.new(self)
    end

    def item
      @item ||= FastBound::Item.new(self)
    end

    def smart_list
      @smart_list ||= FastBound::SmartList.new(self)
    end

    def webhook
      @webhook ||= FastBound::Webhook.new(self)
    end

  end
end
