class One::EmailDirect::Client < Savon::Client

  def initialize(action=nil)
    super() do
      wsdl.document = 'lib/emaildirect.wsdl'
      http.proxy = 'http://dev.emaildirect.com/v1/api.asmx'
    end
    @http.headers['SOAPAction'] = action if !action.nil?
  end

end