require 'fastbound-ruby/api'

module FastBound
  class Account < Base

    include FastBound::API

    ENDPOINTS = {
      fetch: "account".freeze,
    }

    def initialize(client)
      @client = client
    end

    def fetch
      endpoint = ENDPOINTS[:fetch]

      get_request(@client, endpoint)
    end

  end
end
