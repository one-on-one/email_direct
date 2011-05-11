class One::EmailDirect::Facade
  extend One::EmailDirect::Mixins::EmailFacade
  extend One::EmailDirect::Mixins::ListFacade
  extend One::EmailDirect::Mixins::PublicationFacade
  extend One::EmailDirect::Mixins::SourceFacade

  class << self; attr_reader :templates end

  private

    # Loads the SOAP envelope templates.
    def self.load_templates()
      @templates ||= {}
      root_directory = File.dirname(__FILE__)
      directories = [
        "#{root_directory}/mixins/template/email/*.rbxml",
        "#{root_directory}/mixins/template/list/*.rbxml",
        "#{root_directory}/mixins/template/publication/*.rbxml",
        "#{root_directory}/mixins/template/source/*.rbxml"
      ]
      directories.each {|template_directory|
        Dir.glob(template_directory) {|template|
          soap_version = File.basename(template)[4..6]
          template_name = File.basename(template)[7..-7] # remove initial soapxy_ and final .rbxml
          @templates[template_name.to_sym] ||= {}
          @templates[template_name.to_sym][soap_version.to_i] = template
          ## TODO move this to log file
          puts "loaded template :#{template_name} => #{template}"
        }
      }
    end

    def self.create_soap_envelope(method, context)
      raise StandardError, 'There is not template for method %s!' % [method] if !self.templates.has_key? method
      view = Tenjin::Engine.new().render(self.templates[method][context[:soap_version]], context)
      puts '%s\n\t%s' % [method, view]
      view
    end

    # Sends a SOAP request to a web service.
    #
    # @param method [String] the symbol that represents the web service to contact.
    # @param context [Hash] a series of key value pairs to build up the request.
    #                       Use a :soap_version key to 11 for SOAP1.1 envelopes or 12 for SOAP1.2.
    #                       Use a :soap_action if you want to set a SOAPAction HTTP header.
    #
    # @return [Hash] the server response.
    #
    def self.send_soap(method, context)
      context[:soap_version] ||= 11 # by default use SOAP 1.1
      # TODO validate versions
      # TODO log method and context
      client = One::EmailDirect::Client.new context[:soap_action]
      response = client.request method do |soap|
        soap.xml = create_soap_envelope(method, context)
        # TODO log soap envelope @ debug level
      end

      raise StandardError, 'Failed!\n\t%s' % [response] if !response.success?
      return response.to_hash["#{method}_response".to_sym]["#{method}_result".to_sym]
    rescue Savon::SOAP::Fault => fault
      puts fault.to_s
      raise fault
    end

  load_templates()

end