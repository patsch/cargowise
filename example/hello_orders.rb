
$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'

require 'cargowise-ts'

uri, ccode, username, password = *ARGV

client = CargowiseTS::Client.new(:order_uri => uri,
                               :company_code => ccode,
                               :username => username,
                               :password => password)

puts client.orders_hello
