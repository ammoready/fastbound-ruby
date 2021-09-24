require 'fastbound-ruby/api'

module FastBound
  class Acquisition < Base

    include FastBound::API

    CREATE_AND_EDIT_ATTRS = {
      permitted: %i(
        external_id is_manufacturing_acquisition purchase_order_number
        date type note invoice_number shipment_tracking_number
      ).freeze,
      required: %i( type ).freeze
    }

    ENDPOINTS = {
      list:                 "acquisitions".freeze,
      create:               "acquisitions".freeze,
      edit:                 "acquisitions/%s".freeze,
      fetch:                "acquisitions/%s".freeze,
      fetch_by_external_id: "acquisitions/getbyexternalid/%s".freeze,
      delete:               "acquisitions/%s".freeze,
      commit:               "acquisitions/%s/commit".freeze,
      create_and_commit:    "acquisitions/createandcommit".freeze,
      create_item:          "acquisitions/%s/items".freeze,
      edit_item:            "acquisitions/%s/items/%s".freeze,
      fetch_item:           "acquisitions/%s/items/%s".freeze,
      delete_item:          "acquisitions/%s/items/%s".freeze,
      attach_contact:       "acquisitions/%s/attachcontact/%s".freeze
    }

    def initialize(client)
      @client = client
    end

    def list(params = {})
      endpoint = ENDPOINTS[:list] % convert_params_to_request_query(params)

      get_request(@client, endpoint)
    end

    def create(acquisition_data)
      requires!(acquisition_data, CREATE_AND_EDIT_ATTRS[:required])

      endpoint = ENDPOINTS[:create]
      acquisition_data = standardize_body_data(acquisition_data, CREATE_AND_EDIT_ATTRS[:permitted])

      post_request(@client, endpoint, acquisition_data)
    end

    def edit(acquisition_id, acquisition_data)
      endpoint = ENDPOINTS[:edit] % acquisition_id
      acquisition_data = standardize_body_data(acquisition_data, CREATE_AND_EDIT_ATTRS[:permitted])

      put_request(@client, endpoint, acquisition_data)
    end

    def fetch(acquisition_id)
      endpoint = ENDPOINTS[:fetch] % acquisition_id

      get_request(@client, endpoint)
    end

    def fetch_by_external_id(external_id)
      endpoint = ENDPOINTS[:fetch_by_external_id] % external_id

      get_request(@client, endpoint)
    end

    def delete(acquisition_id)
      endpoint = ENDPOINTS[:delete] % acquisition_id

      delete_request(@client, endpoint)
    end

    def commit(acquisition_id)
      endpoint = ENDPOINTS[:commit] % acquisition_id

      post_request(@client, endpoint)
    end

    def create_and_commit(acquisition_data, item_data, contact_data)
      requires!(acquisition_data, CREATE_AND_EDIT_ATTRS[:required])
      requires!(item_data, Item::CREATE_AND_EDIT_ATTRS[:required])
      requires!(contact_data, Contact::CREATE_AND_EDIT_ATTRS[:required])

      endpoint = ENDPOINTS[:create_and_commit]
      acquisition_data = standardize_body_data(acquisition_data, CREATE_AND_EDIT_ATTRS[:permitted])
      item_data = standardize_body_data(item_data, Item::CREATE_AND_EDIT_ATTRS[:permitted])
      contact_data = standardize_body_data(contact_data, Contact::CREATE_AND_EDIT_ATTRS[:permitted])
      request_data = acquisition_data.merge(
        contact: contact_data,
        items: [item_data]
      )

      post_request(@client, endpoint, request_data)
    end

    def create_item(acquisition_id, item_data)
      requires!(item_data, Item::CREATE_AND_EDIT_ATTRS[:required])

      endpoint = ENDPOINTS[:create_item] % acquisition_id
      item_data = standardize_body_data(item_data, Item::CREATE_AND_EDIT_ATTRS[:permitted])

      post_request(@client, endpoint, item_data)
    end

    def edit_item(acquisition_id, item_id, item_data)
      endpoint = ENDPOINTS[:edit_item] % [acquisition_id, item_id]
      item_data = standardize_body_data(item_data, Item::CREATE_AND_EDIT_ATTRS[:permitted])

      put_request(@client, endpoint, item_data)
    end

    def fetch_item(acquisition_id, item_id)
      endpoint = ENDPOINTS[:fetch_item] % [acquisition_id, item_id]

      get_request(@client, endpoint)
    end

    def delete_item(acquisition_id, item_id)
      endpoint = ENDPOINTS[:delete_item] % [acquisition_id, item_id]

      delete_request(@client, endpoint)
    end

    def attach_contact(acquisition_id, contact_id)
      endpoint = ENDPOINTS[:attach_contact] % [acquisition_id, contact_id]

      put_request(@client, endpoint)
    end

  end
end
