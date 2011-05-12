module One::EmailDirect::Mixins::EmailFacade

  # Creates a new email on the given EmailDirect account.
  #
  # @param credentials [One::EmailDirect::Credentials] EmailDirect API credentials.
  # @param email [String] the email address to be added.
  # @param source_id [Fixnum] the source identifier to attach this email to.
  # @param publications [Array] the publication identifiers to attach this email to.
  # @param lists [Array] the list identifiers to attach this email to.
  # @param autoresponder [Fixnum] the auto-responder identifier from the account.
  #                               If '0' is provided then nothing will be sent to the email address.
  # @param force [true,false] Force the addition/update/deletion of an email regardless of it's current state.
  #                           This will preform the method called for any email that has Bounced or opted
  #                           to be Globaly Removed from your account so please use with caution.
  #
  # http://dev.emaildirect.com/v1/api.asmx?op=Email_Add
  #
  def email_add(credentials, email, source_id, publications, lists, autoresponder=0, force=false)
    # TODO: validate mandatory arguments and raise ArgumentError
    response = send_soap(
      :email_add,
      {:soap_action => 'http://espapi.net/v1/Email_Add',
        :credentials => credentials,
        :email => email,
        :source_id => source_id,
        :publications => publications,
        :lists => lists,
        :autoresponder => autoresponder,
        :force => force
      }
    )
    raise StandardError, '[%s] %s' % [response[:code], response[:message]] if response[:code] != '0'
  end



  # Creates a new email on the given EmailDirect account.
  #
  # @param credentials [One::EmailDirect::Credentials] EmailDirect API credentials.
  # @param email [String] the email address to be added.
  # @param source_id [Fixnum] the source identifier to attach this email to.
  # @param publications [Array] the publication identifiers to attach this email to.
  # @param lists [Array] the list identifiers to attach this email to.
  # @param autoresponder [Fixnum] the auto-responder identifier from the account.
  #                               If '0' is provided then nothing will be sent to the email address.
  # @param force [true,false] Force the addition/update/deletion of an email regardless of it's current state.
  #                           This will preform the method called for any email that has Bounced or opted
  #                           to be Globaly Removed from your account so please use with caution.
  # @param custom_fields [Hash] The CustomFields parameter allows you to pass in 0 or
  #                             more CustomField objects to the method.
  #                             A CustomField object is a name/value pair representing a field in your database and
  #                             the value your are passing in.
  #
  # http://dev.emaildirect.com/v1/api.asmx?op=Email_AddWithFields
  #
  def email_addwithfields(credentials, email, source_id, publications, lists, autoresponder=0, force=false, custom_fields={})
    # TODO: validate mandatory arguments and raise ArgumentError
    response = send_soap(
      :email_add_with_fields,
      {:soap_action => 'http://espapi.net/v1/Email_AddWithFields',
        :credentials => credentials,
        :email => email,
        :source_id => source_id,
        :publications => publications,
        :lists => lists,
        :autoresponder => autoresponder,
        :force => force,
        :custom_fields => custom_fields
      }
    )
    raise StandardError, '[%s] %s' % [response[:code], response[:message]] if response[:code] != '0'
  end



  # Deletes an email from the given EmailDirect account.
  #
  # @param credentials [One::EmailDirect::Credentials] EmailDirect API credentials.
  # @param email [String] the email address to be deleted.
  # @param force [true,false] Force the addition/update/deletion of an email regardless of it's current state.
  #                           This will preform the method called for any email that has Bounced or opted
  #                           to be Globaly Removed from your account so please use with caution.
  #
  # http://dev.emaildirect.com/v1/api.asmx?op=Email_Delete
  #
  def email_delete(credentials, email, force)
    response = send_soap(
      :email_delete,
      {:soap_action => 'http://espapi.net/v1/Email_Delete',
        :credentials => credentials,
        :email => email,
        :force => force
      }
    )
    raise StandardError, '[%s] %s' % [response[:code], response[:message]] if response[:code] != '0'
  end



  # Returns all all properties associated with an email address.
  #
  # @param credentials [One::EmailDirect::Credentials] EmailDirect API credentials.
  #
  # http://dev.emaildirect.com/v1/api.asmx?op=Email_GetProperties
  #
  # @return [Hash] Example:
  #                {:date_stamp=>#<DateTime: 1768098599/720,0,2299161>, :ip_address=>nil, :status=>"Active",
  #                 :publications=>{:element=>{:element_id=>"579",
  #                 :description=>"descriptionf43123305dc9012e06f234159e028042",
  #                 :element_name=>"namef43123305dc9012e06f234159e028042"}}, :lists=>{:element=>{:element_id=>"622",
  #                 :description=>"descriptionf43123305dc9012e06f234159e028042",
  #                 :element_name=>"namef43123305dc9012e06f234159e028042"}},
  #                 :email=>"john.doe.f43123305dc9012e06f234159e028042@1on1.com", :email_id=>"108",
  #                 :custom_fields=>{:custom_field=>[{:value=>"john.doe.f43123305dc9012e06f234159e028042@1on1.com",
  #                 :field_name=>"Email"}, {:value=>nil, :field_name=>"IPAddress"}, {:value=>"5/10/2011",
  #                 :field_name=>"DateStamp"}, {:value=>"John", :field_name=>"FirstName"},
  #                 {:value=>"Doe", :field_name=>"LastName"}, {:value=>"30", :field_name=>"Age"}]},
  #                 :create_date=>#<DateTime: 1768098599/720,0,2299161>, :source=>{:element_id=>"452",
  #                 :description=>"descriptionf43123305dc9012e06f234159e028042",
  #                 :element_name=>"namef43123305dc9012e06f234159e028042"}}
  #
  #
  def email_getproperties(credentials, email)
    response = send_soap(
      :email_get_properties,
      {:soap_action => 'http://espapi.net/v1/Email_GetProperties',
        :credentials => credentials,
        :email => email
      }
    )

    if !response.nil?
      # make response consistent
      if !response[:lists].nil?
        lists = response[:lists][:element]
        response[:lists][:element] = [lists] if lists.instance_of? Hash
      else
        response[:lists] = {:element => []}
      end

      if !response[:publications].nil?
        publications = response[:publications][:element]
        response[:publications][:element] = [publications] if publications.instance_of? Hash
      else
        response[:publications] = {:element => []}
      end
    end
    response
  end

end