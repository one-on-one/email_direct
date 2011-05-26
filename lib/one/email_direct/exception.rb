# Class to encapsulate EmailDirect web service errors.
#
class One::EmailDirect::EmailDirectException < StandardError

  attr_reader :code, :message



  # Constructs an EmailDirectException instance.
  #
  # @param code [Fixnum] the webservice error status.
  # @param message [String] the webservice error message.
  #
  def initialize(code, message)
    @code = code
    @message = message
  end



  # Returns a string representation of this object.
  #
  # @return [String] string representation of this object.
  def to_s()
    '[%s] %s' % [@code, @message]
  end

end