require 'rubygems'
require 'savon'
require 'steenzout-cfg'
require 'tenjin'


# 1. loading modules and classes

module One
  module EmailDirect
    module Mixins
      autoload :EmailFacade, "#{File.dirname(__FILE__)}/one/email_direct/mixins/email"
      autoload :ListFacade, "#{File.dirname(__FILE__)}/one/email_direct/mixins/list"
      autoload :PublicationFacade, "#{File.dirname(__FILE__)}/one/email_direct/mixins/publication"
      autoload :SourceFacade, "#{File.dirname(__FILE__)}/one/email_direct/mixins/source"
    end

    autoload :Client, "#{File.dirname(__FILE__)}/one/email_direct/client"
    autoload :Credentials, "#{File.dirname(__FILE__)}/one/email_direct/credentials"
    autoload :EmailDirectException, "#{File.dirname(__FILE__)}/one/email_direct/exception"
    autoload :Facade, "#{File.dirname(__FILE__)}/one/email_direct/facade"

  end
end


# 2. loading configuration settings

configuration_file = 'config/development.yaml' # default
configuration_file = ENV['ONE_CONFIG'] if ENV.has_key? 'ONE_CONFIG'

Steenzout::ConfigurationManager.load configuration_file