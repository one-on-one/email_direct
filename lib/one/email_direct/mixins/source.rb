module One::EmailDirect::Mixins::SourceFacade

  # Creates a new source on the given EmailDirect account.
  #
  # @param credentials [One::EmailDirect::Credentials] EmailDirect API credentials.
  # @param name [String] the source name.
  # @param description [String] the source description.
  #
  # http://dev.emaildirect.com/v1/api.asmx?op=Source_Add
  #
  def source_add(credentials, name, description)
    response = send_soap(
      :source_add,
      {:soap_action => 'http://espapi.net/v1/Source_Add',
        :credentials => credentials,
        :source_name => name,
        :source_description => description}
    )
    raise StandardError, '[%s] %s' % [response[:code], response[:message]] if response[:code] != '0'
  end



  # Deletes a source on the given EmailDirect account.
  #
  # @param credentials [One::EmailDirect::Credentials] EmailDirect API credentials.
  # @param source_id [Fixnum] the unique identifier of the source to be deleted.
  #
  # http://dev.emaildirect.com/v1/api.asmx?op=Source_Delete
  #
  def source_delete(credentials, source_id)
    response = send_soap(
      :source_delete,
      {:soap_action => 'http://espapi.net/v1/Source_Delete',
        :credentials => credentials,
        :source_id => source_id}
    )
    raise StandardError, '[%s] %s' % [response[:code], response[:message]] if response[:code] != '0'
  end



  # Returns the whole information of a source on the given EmailDirect account.
  #
  # @param credentials [
  # @param name [String] the name of the source.
  #
  # @return [Hash] a hash that describes the source.
  #
  def source_get(credentials, name)
    source_getall(credentials).each {|element| return element if element[:element_name] == name}
    nil
  end



  # Returns all sources on the given EmailDirect account.
  #
  # @param credentials [One::EmailDirect::Credentials] EmailDirect API credentials.
  #
  # http://dev.emaildirect.com/v1/api.asmx?op=source_GetAll
  #
  # @return [Hash]  TODO {:description=>"a description.", :element_name=>"name12353", :element_id=>"170"}
  #
  def source_getall(credentials)
    response = send_soap(
      :source_get_all,
      {:soap_action => 'http://espapi.net/v1/Source_GetAll',
       :credentials => credentials}
    )

    # no elements were returned
    return [] if response.nil?

    # if it only has one element (Hash) you have to transform it to a single array element
    return [response[:element]] if response[:element].instance_of? Hash

    # more than 1 element
    if !block_given?
      elements = []
      response[:element].each {|element|
        elements << element
      }
      elements
    else
      response[:element].each {|element| yield element }
    end
  end

end