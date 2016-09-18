# coding: utf-8

require 'cargowise/abstract_result'

module Cargowise

  # A purchase order that is being shipped to from a supplier to
  # you via a logistics company.
  #
  # Typcially you will setup an arrangement with your account manager
  # where they are sent copies of POs so they can be entered into the
  # database and tracked.
  #
  # All order objects are read-only, see the object attributes to see
  # what information is available.
  #
  # Use class find methods to retrieve order info from your logistics
  # company.
  #
  #     Order.find_by_order_number(...)
  #     Order.find_incomplete(...)
  #     etc
  #
  # MiniOrder - used to capture the embedded order data in a web shipment
  class MiniOrder < AbstractResult

    attr_reader :order_number, :order_status, :ordered_at

    def initialize(node)
      @node = node

      @order_number = text_value("./OrderNumber")
      @order_status = text_value("./Status")
      @ordered_at  = text_value("./OrderDate")
    end

    def to_xml
      @node.to_xml
    end

  end

end

