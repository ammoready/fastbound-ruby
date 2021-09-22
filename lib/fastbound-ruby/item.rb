require 'fastbound-ruby/api'

module FastBound
  class Item < Base

    include FastBound::API

    CREATE_AND_EDIT_ATTRS = {
      permitted: %i(
        external_id item_number do_not_dispose note manufacturer importer country_of_manufacture serial model caliber type
        barrel_length total_length condition cost price mpn upc location location_verified_utc ttsn otsn submission_date
        acquisition_type acquire_date acquire_purchase_order_number acquire_invoice_number acquire_shipment_tracking_number
        disposition_type dispose_date dispose_purchase_order_number dispose_invoice_number dispose_shipment_tracking_number
        theft_loss_discovered_date theft_loss_type theft_loss_atf_issued_incident_number theft_loss_police_incident_number
        destroyed_date destroyed_description destroyed_witness_1 destroyed_witness_2
        lightspeed_system_id lightspeed_serial_id lightspeed_sale_id
      ).freeze,
      required: %i( manufacturer model serial caliber type ).freeze
    }

    ENDPOINTS = {
      list:                 "items".freeze,
      fetch:                "items/%s".freeze,
      edit:                 "items/%s".freeze,
      delete:               "items/%s".freeze,
      fetch_by_external_id: "items/getbyexternalid/%s".freeze,
      undispose:            "items/%s/undispose".freeze,
      set_external_id:      "items/%s/setexternalid".freeze,
      set_external_ids:     "items/setexternalids".freeze,
    }

    def initialize(client)
      @client = client
    end

    def list
      endpoint = ENDPOINTS[:list]

      get_request(@client, endpoint)
    end

    def fetch(item_id)
      endpoint = ENDPOINTS[:fetch] % item_id

      get_request(@client, endpoint)
    end

    def edit(item_id, item_data)
      endpoint = ENDPOINTS[:edit] % item_id
      item_data = standardize_body_data(item_data, CREATE_AND_EDIT_ATTRS[:permitted])

      put_request(@client, endpoint, item_data)
    end

    def delete(item_id)
      endpoint = ENDPOINTS[:delete] % item_id

      delete_request(@client, endpoint)
    end

    def fetch_by_external_id(external_id)
      endpoint = ENDPOINTS[:fetch_by_external_id] % external_id

      get_request(@client, endpoint)
    end

    def undispose(item_id)
      endpoint = ENDPOINTS[:undispose] % item_id

      put_request(@client, endpoint)
    end

    def set_external_id(item_id, external_id)
      endpoint = ENDPOINTS[:set_external_id] % item_id
      item_data = { externalId: external_id }

      put_request(@client, endpoint, item_data)
    end

    def set_external_ids(item_id, items)
      endpoint = ENDPOINTS[:set_external_ids] % item_id
      items = items.is_a?(Array) ? items : items[:items]
      item_data = { items: items.each { |h| h[:externalId] ||= h.delete(:external_id) } }

      put_request(@client, endpoint, item_data)
    end

  end
end
