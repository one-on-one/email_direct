require "#{File.dirname(__FILE__)}/helpers/requires"



class TestCredentials < Test::Unit::TestCase

  # NOTE: this test also tests the initialize method.
  def test_create_from

    # using default encrypted password
    config = {
      :account => 'account',
      :password => 'password'
    }

    credentials = One::EmailDirect::Credentials.create_from config
    assert_equal 'account', credentials.account
    assert_equal 'password', credentials.password
    assert_equal '', credentials.encrypted_password


    # using encrypted password
    config = {
      :account => 'account',
      :password => 'password',
      :encrypted_password => 'encrypted_password'
    }

    credentials = One::EmailDirect::Credentials.create_from config
    assert_equal 'account', credentials.account
    assert_equal 'password', credentials.password
    assert_equal 'encrypted_password', credentials.encrypted_password

  end

end