Gem::Specification.new do |s|
  s.name              = "cargowise"
  s.version           = "1.0.16"
  s.summary           = "client library for the ediEnterprise SOAP API by cargowise"
  s.description       = "Retrieve tracking and status information on your shipments from ediEnterprise"
  s.authors           = ["James Healy","Patrick Dockhorn"]
  s.email             = 'patrick@apptastic.com.au'
  s.homepage          = "https://github.com/patsch/cargowise"
  s.files             = Dir.glob("lib/**/*.rb") + Dir.glob("lib/**/*.xml") + Dir.glob("examples/**/*.rb") + ["README.markdown", "CHANGELOG", "TODO", "COPYING", "MIT-LICENSE"]
  s.license           = "MIT"
  s.add_dependency("andand")
  s.add_dependency("savon", "~>2.2.0")
  s.add_dependency("nokogiri", "~>1.4")
  s.add_dependency("mechanize", "~>2.0")
  s.add_dependency("handsoap")
  s.post_install_message = <<END_DESC

  ********************************************

  v1.0.0 of cargowise introduced a new API. There are extensive
  examples showing how to use it in the README and examples directory.

  The old API has been removed, so you will need to update your code
  before it will work with cargowise 1.0.0 or higher.

  This fork is adding additional data elements when parsing the EDI XML.

  ********************************************

END_DESC
end
