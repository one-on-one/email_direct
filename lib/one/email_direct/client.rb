class One::EmailDirect::Client < Savon::Client

  def initialize(soap_action=nil)
    super() do
      wsdl.document = "#{File.dirname(__FILE__)}/../../emaildirect.wsdl"
      http.proxy = 'http://dev.emaildirect.com/v1/api.asmx'
      http.headers['SOAPAction'] = %{"#{soap_action}"} if !soap_action.nil?
    end
  end

end