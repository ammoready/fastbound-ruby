require 'fastbound-ruby/api'

module FastBound
  class Disposition < Base

    include FastBound::API

    CREATE_ATTRS = {
      permitted: %i(
        external_id date type note ttsn generate_ttsn otsn purchase_order_number invoice_number
        shipment_tracking_number is_manufacturing_disposition
      ).freeze,
      required: %i( type ).freeze
    }

    CREATE_AS_NFA_ATTRS = {
      permitted: %i(
        external_id date submission_date type note ttsn generate_ttsn otsn purchase_order_number
        invoice_number shipment_tracking_number
      ).freeze,
      required: %i( type ).freeze
    }

    CREATE_AS_THEFT_LOSS_ATTRS = %i(
      external_id date note theft_loss_discovered_date theft_loss_type theft_loss_police_incident_number
      theft_loss_atf_issued_incident_number
    ).freeze

    CREATE_AS_DESTROYED_ATTRS = %i(
      external_id date note destroyed_date destroyed_description destroyed_witness_1 destroyed_witness_2
    ).freeze

    EDIT_AND_CREATE_COMMIT_ATTRS = [
      %i( request_type contact_id contact_external_id ),
      CREATE_ATTRS[:permitted],
      CREATE_AS_NFA_ATTRS[:permitted],
      CREATE_AS_THEFT_LOSS_ATTRS,
      CREATE_AS_DESTROYED_ATTRS
    ].flatten.uniq.freeze

    ITEM_ATTRS = {
      add: %i( id price ).freeze,
      add_by_external_id: %i( external_id price ).freeze
    }

    COMMIT_ATTRS = %i(
      change_manufacturer change_country_of_manufacture change_importer change_model change_caliber
      change_type change_barrel_length change_overall_length change_condition change_cost change_price
      change_mpn change_upc change_location change_item_note manufacturer country_of_manufacture importer
      model caliber type barrel_length overall_length condition cost price mpn upc location item_note
    ).freeze

    ENDPOINTS = {
      list:                       "dispositions".freeze,
      list_only_with_4473:        "dispositions/only4473s".freeze,
      create:                     "dispositions".freeze,
      create_as_nfa:              "dispositions/nfa".freeze,
      create_as_theft_loss:       "dispositions/theftloss".freeze,
      create_as_destroyed:        "dispositions/destroyed".freeze,
      edit:                       "dispositions/%s".freeze,
      fetch:                      "dispositions/%s".freeze,
      fetch_by_external_id:       "dispositions/getbyexternalid/%s".freeze,
      delete:                     "dispositions/%s".freeze,
      commit:                     "dispositions/%s/commit".freeze,
      create_and_commit:          "dispositions/createandcommit".freeze,
      add_items:                  "dispositions/%s/items".freeze,
      add_items_by_external_id:   "dispositions/%s/items/addbyexternalid".freeze,
      fetch_items:                "dispositions/%s/items".freeze,
      edit_item_price:            "dispositions/%s/items/%s".freeze,
      remove_item:                "dispositions/%s/items/remove/%s".freeze,
      remove_item_by_external_id: "dispositions/%s/items/removebyexternalid/%s".freeze,
      attach_contact:             "dispositions/%s/attachcontact/%s".freeze
    }

    def initialize(client)
      @client = client
    end

    def list(params = {})
      endpoint = ENDPOINTS[:list] % convert_params_to_request_query(params)

      get_request(@client, endpoint)
    end

    def list_only_with_4473(params = {})
      endpoint = ENDPOINTS[:list_only_with_4473] % convert_params_to_request_query(params)

      get_request(@client, endpoint)
    end

    def create(disposition_data)
      requires!(disposition_data, *CREATE_ATTRS[:required])

      endpoint = ENDPOINTS[:create]
      disposition_data = standardize_body_data(disposition_data, CREATE_ATTRS[:permitted])

      post_request(@client, endpoint, disposition_data)
    end

    def create_as_nfa(disposition_data)
      requires!(disposition_data, *CREATE_AS_NFA_ATTRS[:required])

      endpoint = ENDPOINTS[:create_as_nfa]
      disposition_data = standardize_body_data(disposition_data, CREATE_AS_NFA_ATTRS[:permitted])

      post_request(@client, endpoint, disposition_data)
    end

    def create_as_theft_loss(disposition_data)
      endpoint = ENDPOINTS[:create_as_theft_loss]
      disposition_data = standardize_body_data(disposition_data, CREATE_AS_THEFT_LOSS_ATTRS)

      post_request(@client, endpoint, disposition_data)
    end

    def create_as_destroyed(disposition_data)
      endpoint = ENDPOINTS[:create_as_destroyed]
      disposition_data = standardize_body_data(disposition_data, CREATE_AS_DESTROYED_ATTRS)

      post_request(@client, endpoint, disposition_data)
    end

    def edit(disposition_id, disposition_data)
      endpoint = ENDPOINTS[:edit] % disposition_id
      disposition_data = standardize_body_data(disposition_data, EDIT_AND_CREATE_COMMIT_ATTRS)

      put_request(@client, endpoint, disposition_data)
    end

    def fetch(disposition_id)
      endpoint = ENDPOINTS[:fetch] % disposition_id

      get_request(@client, endpoint)
    end

    def fetch_by_external_id(external_id)
      endpoint = ENDPOINTS[:fetch_by_external_id] % external_id

      get_request(@client, endpoint)
    end

    def delete(disposition_id)
      endpoint = ENDPOINTS[:delete] % disposition_id

      delete_request(@client, endpoint)
    end

    def commit(disposition_id, commit_data = {})
      endpoint = ENDPOINTS[:commit] % disposition_id
      commit_data = { manufacturingChanges: standardize_body_data(commit_data, COMMIT_ATTRS) }

      post_request(@client, endpoint, commit_data)
    end

    def create_and_commit(disposition_data, items_data, contact_data, commit_data = {})
      requires!(contact_data, *Contact::CREATE_AND_EDIT_ATTRS[:required])
      items_data.each { |item| requires!(item, :id) }

      endpoint = ENDPOINTS[:create_and_commit]
      disposition_data = standardize_body_data(disposition_data, EDIT_AND_CREATE_COMMIT_ATTRS)
      items_data = items_data.map { |item| standardize_body_data(item, ITEM_ATTRS[:add]) }
      contact_data = standardize_body_data(contact_data, Contact::CREATE_AND_EDIT_ATTRS[:permitted])
      request_data = disposition_data.merge(
        contact: contact_data,
        items: items_data,
        manufacturingChanges: commit_data
      )

      post_request(@client, endpoint, request_data)
    end

    def add_items(disposition_id, items_data)
      items_data.each { |item| requires!(item, :id) }

      endpoint = ENDPOINTS[:add_items] % disposition_id
      items_data = { items: items_data.map { |item| standardize_body_data(item, ITEM_ATTRS[:add]) } }

      post_request(@client, endpoint, items_data)
    end

    def add_items_by_external_id(disposition_id, items_data)
      items_data.each { |item| requires!(item, :external_id) }

      endpoint = ENDPOINTS[:add_items_by_external_id] % disposition_id
      items_data = { items: items_data.map { |item| standardize_body_data(item, ITEM_ATTRS[:add_by_external_id]) } }

      post_request(@client, endpoint, items_data)
    end

    def fetch_items(disposition_id)
      endpoint = ENDPOINTS[:fetch_items] % disposition_id

      get_request(@client, endpoint)
    end

    def edit_item_price(disposition_id, item_id, price)
      endpoint = ENDPOINTS[:edit_item_price] % [disposition_id, item_id]
      item_data = { price: price }

      put_request(@client, endpoint, item_data)
    end

    def remove_item(disposition_id, item_id)
      endpoint = ENDPOINTS[:remove_item] % [disposition_id, item_id]

      delete_request(@client, endpoint)
    end

    def remove_item_by_external_id(disposition_id, external_id)
      endpoint = ENDPOINTS[:remove_item_by_external_id] % [disposition_id, external_id]

      delete_request(@client, endpoint)
    end

    def attach_contact(disposition_id, contact_id)
      endpoint = ENDPOINTS[:attach_contact] % [disposition_id, contact_id]

      put_request(@client, endpoint)
    end

  end
end
