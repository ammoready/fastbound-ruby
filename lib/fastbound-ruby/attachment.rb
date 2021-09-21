require 'fastbound-ruby/api'

module FastBound
  class Attachment < Base

    include FastBound::API

    ENDPOINTS = {
      download: "attachments/download/%s".freeze,
    }

    def initialize(client)
      @client = client
    end

    def download(attachment_id)
      endpoint = ENDPOINTS[:download] % attachment_id

      get_request(@client, endpoint)
    end

  end
end
