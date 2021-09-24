require 'fastbound-ruby/api'

module FastBound
  class SmartList < Base

    include FastBound::API

    ENDPOINTS = {
      acquire_type:               "smartlists/acquiretype".freeze,
      caliber:                    "smartlists/caliber".freeze,
      condition:                  "smartlists/condition".freeze,
      country_of_manufacture:     "smartlists/countryofmanufacture".freeze,
      delete_type:                "smartlists/deletetype".freeze,
      dispose_type:               "smartlists/disposetype".freeze,
      importer:                   "smartlists/importer".freeze,
      item_type:                  "smartlists/itemtype".freeze,
      license_type:               "smartlists/licensetype".freeze,
      location:                   "smartlists/location".freeze,
      theft_loss_type:            "smartlists/theftlosstype".freeze,
      manufacturer:               "smartlists/manufacturer".freeze,
      manufacturing_dispose_type: "smartlists/manufacturingdisposetype".freeze,
      manufacturing_acquire_type: "smartlists/manufacturingacquiretype".freeze
    }

    def initialize(client)
      @client = client
    end

    ENDPOINTS.keys.each do |endpoint|
      define_method(endpoint) { get_request(@client, ENDPOINTS[endpoint]) }
    end

  end
end
