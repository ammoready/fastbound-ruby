require 'fastbound-ruby/api'

module FastBound
  class Item < Base

    include FastBound::API

    EDIT_ATTRS = %i(
      externalId itemNumber doNotDispose note manufacturer importer countryOfManufacture serial model caliber
      type barrelLength totalLength condition cost price mpn upc location locationVerifiedUtc acquire_Date
      acquisitionType acquire_PurchaseOrderNumber acquire_InvoiceNumber acquire_ShipmentTrackingNumber
      dispose_Date dispositionType dispose_PurchaseOrderNumber dispose_InvoiceNumber dispose_ShipmentTrackingNumber
      ttsn otsn submissionDate theftLoss_DiscoveredDate theftLoss_Type theftLoss_ATFIssuedIncidentNumber
      theftLoss_PoliceIncidentNumber destroyed_Date destroyed_Description destroyed_Witness1 destroyed_Witness2
      lightspeedSystemID lightspeedSerialID lightspeedSaleID
    ).freeze

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
      item_data = standardize_body_data(item_data, EDIT_ATTRS)

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
