require 'fastbound-ruby/api'

module FastBound
  class Contact < Base

    include FastBound::API

    CREATE_AND_EDIT_ATTRS = {
      permitted: %i(
        external_id ffl_number ffl_expires lookup_ffl license_name trade_name sotein sot_class business_type
        organization_name first_name middle_name last_name premise_address_1 premise_address_2 premise_city
        premise_county premise_state premise_zip_code premise_country phone_number fax email_address
      ).freeze,
      required:  %i( ffl_number ffl_expires premise_address_1 premise_city premise_state premise_zip_code ).freeze
    }

    CREATE_AND_EDIT_LICENSE_ATTRS = {
      permitted: %i( type number expiration copy_on_file ).freeze,
      required:  %i( type number ).freeze
    }

    MERGE_ATTRS = {
      permitted: %i( winning_contact_id losing_contact_id ).freeze,
      required:  %i( winning_contact_id losing_contact_id ).freeze
    }

    ENDPOINTS = {
      list:                 "contacts?%s".freeze,
      create:               "contacts".freeze,
      edit:                 "contacts/%s".freeze,
      fetch:                "contacts/%s".freeze,
      fetch_by_external_id: "contacts/getbyexternalid/%s".freeze,
      delete:               "contacts/%s".freeze,
      merge:                "contacts/merge".freeze,
      create_license:       "contacts/%s/licenses".freeze,
      edit_license:         "contacts/%s/licenses/%s".freeze,
      fetch_license:        "contacts/%s/licenses/%s".freeze,
      delete_license:       "contacts/%s/licenses/%s".freeze,
    }

    def initialize(client)
      @client = client
    end

    def list(params = {})
      endpoint = ENDPOINTS[:list] % convert_params_to_request_query(params)

      get_request(@client, endpoint)
    end

    def create(contact_data)
      requires!(contact_data, CREATE_AND_EDIT_ATTRS[:required])

      endpoint = ENDPOINTS[:create]
      contact_data = standardize_body_data(contact_data, CREATE_AND_EDIT_ATTRS[:permitted])

      post_request(@client, endpoint, contact_data)
    end

    def edit(contact_id, contact_data)
      endpoint = ENDPOINTS[:edit] % contact_id
      contact_data = standardize_body_data(contact_data, CREATE_AND_EDIT_ATTRS[:permitted])

      put_request(@client, endpoint, contact_data)
    end

    def fetch(contact_id)
      endpoint = ENDPOINTS[:fetch] % contact_id

      get_request(@client, endpoint)
    end

    def fetch_by_external_id(external_id)
      endpoint = ENDPOINTS[:fetch_by_external_id] % external_id

      get_request(@client, endpoint)
    end

    def delete(contact_id)
      endpoint = ENDPOINTS[:delete] % contact_id

      delete_request(@client, endpoint)
    end

    def merge(merge_data)
      requires!(merge_data, MERGE_ATTRS[:required])

      endpoint = ENDPOINTS[:merge]
      merge_data = standardize_body_data(merge_data, MERGE_ATTRS[:permitted])

      post_request(@client, endpoint, merge_data)
    end

    def create_license(contact_id, license_data)
      requires!(license_data, CREATE_AND_EDIT_LICENSE_ATTRS[:required])

      endpoint = ENDPOINTS[:create_license] % contact_id
      license_data = standardize_body_data(license_data, CREATE_AND_EDIT_LICENSE_ATTRS[:permitted])

      post_request(@client, endpoint, license_data)
    end

    def edit_license(contact_id, license_data)
      endpoint = ENDPOINTS[:edit_license] % contact_id
      license_data = standardize_body_data(license_data, CREATE_AND_EDIT_LICENSE_ATTRS[:permitted])

      put_request(@client, endpoint, license_data)
    end

    def fetch_license(contact_id, license_id)
      endpoint = ENDPOINTS[:fetch_license] % [contact_id, license_id]

      get_request(@client, endpoint)
    end

    def delete_license(contact_id, license_id)
      endpoint = ENDPOINTS[:delete_license] % [contact_id, license_id]

      delete_request(@client, endpoint)
    end

  end
end
