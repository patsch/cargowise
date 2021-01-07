# coding: utf-8

module Cargowise

  # Superclass of all objects built to contain results from
  # the API. Not much to see here, mostly common helper methods
  # for parsing values out of the XML response.
  #
  class AbstractResult # :nodoc:

    def inspect
      str = "<#{self.class}: "
      str << inspectable_vars.map { |v| "#{v.to_s.tr('@','')}: #{instance_variable_get(v)}" }.join(" ")
      str << ">"
      str
    end

    private

    def node
      @node
    end

    def inspectable_vars
      instance_variables.select { |var| var.to_s != "@node"}
    end

    def node_array(path)
      path = path.gsub("/","/tns:")
      node.xpath("#{path}", "tns" => Cargowise::DEFAULT_NS)
    end

    def text_value(path)
      path = path.gsub("/","/tns:")
      deunicode(node.xpath("#{path}/text()", "tns" => Cargowise::DEFAULT_NS).to_s)
    end

    def deunicode(s)
      ret = s
      if !s.blank?
        ret = s.gsub("_x0020_"," ").gsub("_x002F_","/").gsub("_x002f_","/").gsub("_x00b4_","'").gsub("_x00B4_","'").gsub("_x002B_","+").gsub("_x002b_","+")
      end
      ret
    end

    def attribute_value(path)
      path = path.gsub(/\/([^@])/u,'/tns:\1')
      deunicode(node.xpath(path, "tns" => Cargowise::DEFAULT_NS).to_s)
    end

    def time_value(path)
      val = text_value(path)
      val.nil? || val.strip.length == 0 ? nil : DateTime.parse(val)
    rescue ArgumentError
      return nil
    end

    def decimal_value(path)
      val = text_value(path)
      val.nil? || val.strip.length == 0 ? nil : BigDecimal(val)
    end

    # return a weight value in KG. Transparently handles the
    # conversion from other units.
    #
    def kg_value(path)
      val  = text_value(path)
      type = attribute_value("#{path}/@DimensionType")

      if type.to_s.downcase == "kg"
        BigDecimal(val)
      elsif type.to_s.downcase == "lb"
        val = BigDecimal(val) * BigDecimal("0.45359237")
        val.round(4)
      else
        nil
      end
    end

    # return a cubic value in meters cubed. Transparently handles the
    # conversion from other units.
    #
    def cubic_value(path)
      val  = text_value(path)
      type = attribute_value("#{path}/@DimensionType")

      if type.to_s.downcase == "m3" # cubic metres
        BigDecimal(val)
      elsif type.to_s.downcase == "cf" # cubic feet
        val = BigDecimal(val) * BigDecimal("0.0283168466")
        val.round(4)
      else
        nil
      end
    end

    # creates quantity value with correct type (probably ALWAS is CTN)
    def quantity_value(path)
      val  = text_value(path)
      type = attribute_value("#{path}/@DimensionType")
      xtype = type.to_s # type.to_s.downcase == "ctn" ? "Containers" : type.to_s
      "#{val} #{xtype}"
    end
  end
end
