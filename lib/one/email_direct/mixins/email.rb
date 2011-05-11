module One::EmailDirect::Mixins::EmailFacade

  # Creates a new email on the given EmailDirect account.
  #
  # @param credentials [One::EmailDirect::Credentials] EmailDirect API credentials.
  # @param email [String] the email address to be added.
  # @param source_id [Fixnum] the source identifier to attach this email to.
  # @param publications [Array] the publication identifiers to attach this email to.
  # @param lists [Array] the list identifiers to attach this email to.
  # @param autoresponder [Fixnum] the auto-responder identifier.
  # @param force [true,false] Force the addition/update/deletion of an email regardless of it's current state.
  #                           This will preform the method called for any email that has Bounced or opted
  #                           to be Globaly Removed from your account so please use with caution.
  #
  # http://dev.emaildirect.com/v1/api.asmx?op=Email_Add
  #
  def email_add(credentials, email, source_id, publications, lists, autoresponder, force=false)
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

end