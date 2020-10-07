# coding: utf-8

require 'cargowise/abstract_result'

module Cargowise

  # A note that is associated with a Shipment. Not built
  # directly, but available via the notes() attribute
  # of the Shipment model.
  #
  class Note < AbstractResult

    attr_reader :created_at, :note_type, :note_data

    def initialize(node)
      @node = node

      @created_at     = time_value("./NoteCreatedDateTime")
      @note_type      = text_value("./NoteType")
      @note_text      = text_value("./NoteData")
    end
  end
end
