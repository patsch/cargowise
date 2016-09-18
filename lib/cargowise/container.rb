# coding: utf-8

require 'cargowise/abstract_result'

module Cargowise

  # Extra shipping detail associated with a Shipment. Not built
  # directly, but available via the consols() attribute
  # of the Shipment model.
  #
  class Container < AbstractResult

    attr_reader :container_number, :number_of_containers
    attr_reader :kg, :seal_number
    attr_reader :mode, :delivery_mode

    def initialize(node)

      @node = node

      @container_number       = text_value("./ContainerNumber")
      @number_of_containers   = text_value("./NumberOfContainers")
      @kg                     = kg_value("./Weight")
      @seal_number            = text_value("./SealNumber")
      @mode                   = text_value("./Mode")
      @delivery_mode          = text_value("./DeliveryMode")
    end
  end
end
