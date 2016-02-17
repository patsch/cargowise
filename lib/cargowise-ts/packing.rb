# coding: utf-8

require 'cargowise-ts/abstract_result'

module CargowiseTS

  # Extra packing detail associated with a Shipment. Not built
  # directly, but available via the packings attribute
  # of the Shipment model.
  #
  class Packing < AbstractResult

    attr_reader :pack_type, :line_price, :weight, :volume, :description

    def initialize(node)
      @node = node

      @pack_type   = text_value("./PackType")
      @line_price  = decimal_value("./LinePrice")
      @weight      = kg_value("./Weight")
      @volume      = cubic_value("./Volume")
      @description = text_value("./Description")
    end
  end
end
