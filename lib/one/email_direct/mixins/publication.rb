module One::EmailDirect::Mixins::PublicationFacade

  # Creates a new publication on the given EmailDirect account.
  #
  # @param credentials [One::EmailDirect::Credentials] EmailDirect API credentials.
  # @param name [String] the publication name.
  # @param description [String] the publication description.
  #
  # http://dev.emaildirect.com/v1/api.asmx?op=Publication_Add
  #
  def publication_add(credentials, name, description)
    response = send_soap(
      :publication_add,
      {:soap_action => 'http://espapi.net/v1/Publication_Add',
        :credentials => credentials,
        :publication_name => name,
        :publication_description => description}
    )
    raise StandardError, '[%s] %s' % [response[:code], response[:message]] if response[:code] != '0'
  end



  # Deletes a publication on the given EmailDirect account.
  #
  # @param credentials [One::EmailDirect::Credentials] EmailDirect API credentials.
  # @param publication_id [Fixnum] the unique identifier of the publication to be deleted.
  #
  # http://dev.emaildirect.com/v1/api.asmx?op=Publication_Delete
  #
  def publication_delete(credentials, publication_id)
    response = send_soap(
      :publication_delete,
      {:soap_action => 'http://espapi.net/v1/Publication_Delete',
        :credentials => credentials,
        :publication_id => publication_id}
    )
    raise StandardError, '[%s] %s' % [response[:code], response[:message]] if response[:code] != '0'
  end



  # Returns the whole information of a publication on the given EmailDirect account.
  #
  # @param credentials [
  # @param name [String] the name of the publication.
  #
  # @return [Hash] a hash that describes the publication.
  #
  def publication_get(credentials, name)
    publication_getall(credentials).each {|element| return element if element[:element_name] == name}
    nil
  end



  # Returns all publications on the given EmailDirect account.
  #
  # @param credentials [One::EmailDirect::Credentials] EmailDirect API credentials.
  #
  # http://dev.emaildirect.com/v1/api.asmx?op=Publication_GetAll
  #
  # @return [Array] all of the publications.
  #                 [{:description=>"a description.", :element_name=>"name12353", :element_id=>"170"}, ...]
  #
  def publication_getall(credentials)
    response = send_soap(
      :publication_getall,
      {:soap_action => 'http://espapi.net/v1/Publication_GetAll',
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