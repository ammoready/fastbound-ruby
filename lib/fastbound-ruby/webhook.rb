require 'fastbound-ruby/api'

module FastBound
  class Webhook < Base

    include FastBound::API

    CREATE_AND_EDIT_ATTRS = {
      permitted: %i( name url description events ).freeze,
      required:  %i( name url events ).freeze
    }

    ENDPOINTS = {
      create: "webhooks".freeze,
      edit:   "webhooks/%s".freeze,
      fetch:  "webhooks/%s".freeze,
      delete: "webhooks/%s".freeze,
      events: "webhooks/events".freeze
    }

    def initialize(client)
      @client = client
    end

    def create(webhook_data)
      requires!(webhook_data, *CREATE_AND_EDIT_ATTRS[:required])

      endpoint = ENDPOINTS[:create]
      webhook_data = standardize_body_data(webhook_data, CREATE_AND_EDIT_ATTRS[:permitted])

      post_request(@client, endpoint, webhook_data)
    end

    def edit(webhook_name, webhook_data)
      endpoint = ENDPOINTS[:edit] % webhook_name
      webhook_data = standardize_body_data(webhook_data, CREATE_AND_EDIT_ATTRS[:permitted])

      put_request(@client, endpoint, webhook_data)
    end

    def fetch(webhook_name)
      endpoint = ENDPOINTS[:fetch] % webhook_name

      get_request(@client, endpoint)
    end

    def delete(webhook_name)
      endpoint = ENDPOINTS[:delete] % webhook_name

      delete_request(@client, endpoint)
    end

    def events
      endpoint = ENDPOINTS[:events]

      get_request(@client, endpoint)
    end

  end
end
