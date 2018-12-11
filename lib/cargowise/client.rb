# coding: utf-8

require 'savon'
require 'cargowise/order_search'
require 'cargowise/shipment_search'

module Cargowise

  # The starting point for accessing data from your logistics provider. See
  # the README for usage tips.
  #
  # You should create a new Client instance for each company API you plan
  # to query.
  #
  class Client

    def initialize(opts = {})
      @order_uri = opts[:order_uri]
      @shipment_uri = opts[:shipment_uri]
      @code = opts[:company_code]
      @username = opts[:username]
      @password = opts[:password]
      @timeout = opts[:timeout]
      @timeout ||= 600
    end

    # begin an order search. See the docs for Cargowise::OrderSearch for info
    # on what you can do with the object returned from this method.
    def orders
      OrderSearch.new(orders_client)
    end

    # begin a shipment search. See the docs for Cargowise::ShipmentSearch for
    # info on what you can do with the object returned from this method.
    def shipments
      ShipmentSearch.new(shipments_client)
    end

    def orders_hello
      response = orders_client.call(:hello)
      response.xpath("//tns:HelloResponse/tns:HelloResult/text()", {"tns" => Cargowise::DEFAULT_NS}).to_s
    end

    def shipments_hello
      response = shipments_client.call(:hello)
      response.xpath("//tns:HelloResponse/tns:HelloResult/text()", {"tns" => Cargowise::DEFAULT_NS}).to_s
    end

    # Find the base URI for the web interface at this client
    #
    def base_uri
      uri = @shipment_uri || @order_uri || ""
      uri.to_s[/(.+)\/WebService.+/,1]
    end

    private

    def orders_client
      build_client(order_wsdl_path, @order_uri)
    end

    def order_wsdl_path
      File.join(
        File.dirname(__FILE__),
        "order_wsdl.xml"
      )
    end

    def shipments_client
      build_client(shipment_wsdl_path, @shipment_uri)
    end

    def shipment_wsdl_path
      File.join(
        File.dirname(__FILE__),
        "shipment_wsdl.xml"
      )
    end

    # TODO: make some of these configurable via the initialize to Cargowise::Client. Will enable
    #       providers that need special treatment to work (like OHL) to be configured differently
    #       by the calling code
    def build_client(wsdl_path, endpoint_uri)
      Savon.client(
        wsdl: wsdl_path,
        endpoint: endpoint_uri,

        # Cargowise servers can be super slow to respond, this gives them time
        # to have a smoko before responding to our queries.
        read_timeout: @timeout,

        # OHL uses cargowise and has a load balancer that freaks out if we use
        # the OpenSSL 1.0.1 default of TLS1.1.
        ssl_version: :TLSv1,

        # savon 2.2.0 ignores the above ssl_version unless this is set to
        # false. Annoying.
        ssl_verify_mode: :none,

        # turn off logging to keep me sane. Change this to true when developing
        log: false,

        # the cargowsie API requires auth details in the SOAP header of every
        # request
        soap_header: {
          "tns:WebTrackerSOAPHeader" => {
            "tns:CompanyCode" => @code,
            "tns:UserName" => @username,
            "tns:Password" => @password
          }
        }
      )
    end
  end
end
