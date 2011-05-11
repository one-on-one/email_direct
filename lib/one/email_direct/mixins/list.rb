module One::EmailDirect::Mixins::ListFacade

  # Creates a new list on the given EmailDirect account.
  #
  # @param credentials [One::EmailDirect::Credentials] EmailDirect API credentials.
  # @param name [String] the list name.
  # @param description [String] the list description.
  #
  # http://dev.emaildirect.com/v1/api.asmx?op=List_Add
  #
  def list_add(credentials, name, description)
    response = send_soap(
      :list_add,
      {:soap_action => 'http://espapi.net/v1/List_Add',
        :credentials => credentials,
        :list_name => name,
        :list_description => description}
    )
    raise StandardError, '[%s] %s' % [response[:code], response[:message]] if response[:code] != '0'
  end



  # Deletes a list from the given EmailDirect account.
  #
  # @param credentials [One::EmailDirect::Credentials] EmailDirect API credentials.
  # @param list_id [Fixnum] the unique identifier of the list to be deleted.
  #
  # http://dev.emaildirect.com/v1/api.asmx?op=List_Delete
  #
  def list_delete(credentials, list_id)
    response = send_soap(
      :list_delete,
      {:soap_action => 'http://espapi.net/v1/List_Delete',
        :credentials => credentials,
        :list_id => list_id}
    )
    raise StandardError, '[%s] %s' % [response[:code], response[:message]] if response[:code] != '0'
  end



  # Returns the whole information of a list on the given EmailDirect account.
  #
  # @param credentials [
  # @param name [String] the name of the list.
  #
  # @return [Hash] a hash that describes the list.
  #
  def list_get(credentials, name)
    list_get_all(credentials).each {|element| return element if element[:element_name] == name}
    nil
  end



  # Returns all list on the given EmailDirect account.
  #
  # @param credentials [One::EmailDirect::Credentials] EmailDirect API credentials.
  #
  # http://dev.emaildirect.com/v1/api.asmx?op=List_GetAll
  #
  # @return [Hash]  TODO {:description=>"a description.", :element_name=>"name12353", :element_id=>"170"}
  #
  def list_get_all(credentials)
    response = send_soap(
      :list_get_all,
      {:soap_action => 'http://espapi.net/v1/List_GetAll',
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

  # Returns all subscribers associated to a list on the given EmailDirect account.
  #
  # @param credentials [One::EmailDirect::Credentials] EmailDirect API credentials.
  # @param list_id [Fixnum] the unique identifier of the list.
  # @param page_size [Fixnum] the number of subscribers to present per page.
  # @param page_number [Fixnum] the page number to present.
  #
  # http://dev.emaildirect.com/v1/api.asmx?op=List_GetMembers
  #
  # @return [Hash]  TODO {:description=>"a description.", :element_name=>"name12353", :element_id=>"170"}
  #
  def list_get_members(credentials, list_id, page_size, page_number)
    response = send_soap(
      :list_get_members,
      {:soap_action => 'http://espapi.net/v1/List_GetMembers',
        :credentials => credentials,
        :list_id => list_id,
        :page_size => page_size,
        :page_number => page_number}
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