# coding: utf-8

require 'cargowise/abstract_result'

module Cargowise

  # Extra shipping detail associated with a Shipment. Not built
  # directly, but available via the consols() attribute
  # of the Shipment model.
  #
  class Consol < AbstractResult

    attr_reader :master_bill, :consol_mode, :transport_mode
    attr_reader :vessel_name, :voyage_flight
    attr_reader :load_port, :discharge_port

    def initialize(node)

      @node = node

      @master_bill    = text_value("./MasterBill")
      @consol_mode   = text_value("./ConsolMode")
      @transport_mode = text_value("./TransportMode")
      @vessel_name    = text_value("./VesselName")
      @voyage_flight  = text_value("./VoyageFlight")
      @load_port      = text_value("./LoadPort")
      @discharge_port = text_value("./DischargePort")
      # PD 04/07/2020 : Added ATD / ATA
      @atd           = time_value("./ATD")
      @ata           = time_value("./ATA")
    end
  end
end
