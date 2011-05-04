# Class to hold EmailDirect API credentials.
#
# @author Steenzout <https://github.com/steenzout>
#
# @attr_reader account [String] EmailDirect account username.
# @attr_reader password [String] the API password configured in the EmailDirect web interface.
# @attr_reader encrypted_password [String] optional encryped password (future use).
#
class One::EmailDirect::Credentials

  attr_reader :account, :password, :encrypted_password


  # Constructs a Credentials instance.
  #
  # @param account [String] the EmailDirect account.
  # @param password [String] the EmailDirect API password.
  #
  def initialize(account, password, encrypted_password='')
    encrypted_password ||= ''

    @account = account
    @password = password
    @encrypted_password = encrypted_password
  end



  # Create credentials from a hash.
  #
  # @param config [Hash] a hash which contains the EmailDirect account credentials.
  #
  # @return [One::EmailDirect::Credentials] the EmailDirect account credentials.
  #
  def self.create_from(config)
    return One::EmailDirect::Credentials.new(
      config[:account],
      config[:password],
      config[:encrypted_password])
  end

end