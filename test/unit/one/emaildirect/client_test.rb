require "#{File.dirname(__FILE__)}/helpers/requires"



class TestClient < Test::Unit::TestCase

  def setup()

  end

  def teardown()

  end

  def test_default()

    client = Savon::Client.new do |wsdl, http|
      wsdl.document = 'lib/emaildirect.wsdl'
      http.proxy = 'http://dev.emaildirect.com/v1/api.asmx'
    end

    return

    response = client.request :publication_get_all do |soap|
      soap.xml = '<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <Publication_GetAll xmlns="http://espapi.net/v1/">
      <Creds xmlns="http://espapi.net/v1/components/credentials">
        <AccountName>%s</AccountName>
        <Password>%s</Password>
        <Enc></Enc>
      </Creds>
    </Publication_GetAll>
  </soap:Body>
</soap:Envelope>' % ['oootest', 'qU34Lsj+2a8&lt;H6cQrbXK']
    end

    p 'response'
    p response

    assert true

  end

end
