require 'fastbound-ruby/base'
require 'fastbound-ruby/version'

require 'fastbound-ruby/api'
require 'fastbound-ruby/account'
require 'fastbound-ruby/acquisition'
require 'fastbound-ruby/attachment'
require 'fastbound-ruby/client'
require 'fastbound-ruby/contact'
require 'fastbound-ruby/disposition'
require 'fastbound-ruby/error'
require 'fastbound-ruby/item'
require 'fastbound-ruby/response'
require 'fastbound-ruby/smart_list'
require 'fastbound-ruby/webhook'

module FastBound
  class << self
    attr_accessor :config
  end

  def self.config
    @config ||= Configuration.new
  end

  def self.configure
    yield(config)
  end

  class Configuration
    attr_accessor :full_debug

    alias :full_debug? :full_debug

    def initialize
      @full_debug ||= false
    end
  end
end
