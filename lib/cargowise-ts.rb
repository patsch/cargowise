# encoding: utf-8

# stdlib
require "bigdecimal"

# gems
require 'mechanize'
require 'andand'

module CargowiseTS
  DEFAULT_NS = "http://www.edi.com.au/EnterpriseService/"
  CA_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt"
end

# this lib
require 'cargowise-ts/client'

# Make savon/httpi always use Net::HTTP for HTTP requests. It supports
# forcing the connection to TLSv1 (needed for OHL)
HTTPI.adapter = :net_http
