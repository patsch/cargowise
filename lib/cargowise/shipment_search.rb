# coding: utf-8

require 'cargowise/shipment'

module Cargowise

  class ShipmentSearch

    attr_accessor :ccode
    def initialize(savon_client, ccode = nil)
      @savon_client = savon_client
      @ccode = ccode
    end

    # find all shipments with a MasterBillNumber that matches ref
    #
    def by_masterbill_number(ref)
      by_number("MasterBillNumber", ref)
    end

    # find all shipments with a ShipmentNumber that matches ref
    #
    def by_shipment_number(ref)
      by_number("ShipmentNumber", ref)
    end

    # find all shipments that haven't been delivered yet.
    #
    # This times out on some systems, possibly because the logistics company
    # isn't correctly marking shipments as delivered, so the result is too
    # large to transfer in a timely manner.
    #
    def undelivered
      filter_hash = {
        "tns:Filter" => { "tns:Status" => "Undelivered" }
        }
      get_shipments_list(filter_hash)
    end

    # find all shipments that had some activity in the past fourteen days. This could
    # include leaving port, being delivered or passing a milestone.
    #
    def with_recent_activity(range = 14)
      filter_hash = {
        "tns:Filter" => {
          "tns:Date" => {
            "tns:DateSearchField" => "ALL",
            "tns:FromDate" => (Date.today - range).strftime("%Y-%m-%d"),
            "tns:ToDate" => (Date.today + range).strftime("%Y-%m-%d")
          }
        }
      }
      get_shipments_list(filter_hash)
    end

    # find all shipments that had were shipped in the past 14 days or will ship in
    # the next 14 days
    #
    def recently_shipped
      filter_hash = {
        "tns:Filter" => {
          "tns:Date" => {
            "tns:DateSearchField" => "ETD",
            "tns:FromDate" => (Date.today - 14).strftime("%Y-%m-%d"),
            "tns:ToDate" => (Date.today + 14).strftime("%Y-%m-%d")
          }
        }
      }
      get_shipments_list(filter_hash)
    end

    # PD allowing access private

    def by_number(field, ref)
      filter_hash = {
        "tns:Filter" => {
          "tns:Number" => {
            "tns:NumberSearchField" => field,
            "tns:NumberValue" => ref
          }
        }
      }
      get_shipments_list(filter_hash)
    end

    # return an array of shipments. Each shipment should correspond to
    # a consolidated shipment from the freight company.
    #
    # filter_hash should be a hash that will be serialised into an
    # XML fragment specifying the search criteria. See the WSDL documentation
    # for samples
    #
    def get_shipments_list(filter_hash)
      response = @savon_client.call(:get_shipments_list, message: filter_hash)
      if false
        # PD dump responses - see /Users/patsch/.rvm/gems/ruby-2.3.8@e-connect/bundler/gems/cargowise-04044332ef0b/lib/cargowise
        @code = "UNKNOWN" if @ccode.blank?
        cdir = "#{Rails.root}/log/#{@ccode}"
        Dir.mkdir(cdir) if !File.exist?(cdir)
        filename = "#{cdir}/#{Time.now.strftime('%Y-%m-%d-%H-%M-%S')}.json"
        File.open("#{Rails.root}/log/cargowise.log","at") { |f| f.puts "#{Time.now.strftime('%d/%m/%Y %H:%M:%S')} #{@ccode} : Data received in #{filename}" }
        File.open(filename,"wb") { |f| f.write response.to_xml }
      end

      response.xpath("//tns:GetShipmentsListResult/tns:WebShipment", {"tns" => Cargowise::DEFAULT_NS}).map do |node|
        Cargowise::Shipment.new(node)
      end
    end

  end
end

