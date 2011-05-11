require "#{File.dirname(__FILE__)}/../helpers/requires"



class TestEmailFacade < Test::Unit::TestCase

  def setup()

    # preparation to build test resources
    config = Steenzout::ConfigurationManager.configuration_for_gem :'one-emaildirect'
    @credentials = One::EmailDirect::Credentials.create_from config

    generator = UUID.new()
    uuid1 = generator.generate(:compact)
    uuid2 = generator.generate(:compact)

    @list1 = {:name => "name#{uuid1}", :description => "description#{uuid1}"}
    @list2 = {:name => "name#{uuid2}", :description => "description#{uuid2}"}

    @publication1 = @list1.clone
    @publication2 = @list2.clone

    @source1 = @list1.clone
    @source2 = @list2.clone

    @email1 = 'john.doe.%s@1on1.com' % [uuid1]
    @email2 = 'john.doe.%s@1on1.com' % [uuid2]
    @email2 = 'john.doe.%s@1on1.com' % [generator.generate(:compact)]
    @email3 = 'john.doe.%s@1on1.com' % [generator.generate(:compact)]
    @email4 = 'john.doe.%s@1on1.com' % [generator.generate(:compact)]
    @email5 = 'john.doe.%s@1on1.com' % [generator.generate(:compact)]
    @email6 = 'john.doe.%s@1on1.com' % [generator.generate(:compact)]
    @email7 = 'john.doe.%s@1on1.com' % [generator.generate(:compact)]

    @autoresponder = 0
    @force = false


    # create test resources
    One::EmailDirect::Facade.source_add(@credentials, @source1[:name], @source1[:description])
    One::EmailDirect::Facade.source_add(@credentials, @source2[:name], @source2[:description])
    One::EmailDirect::Facade.list_add(@credentials, @list1[:name], @list1[:description])
    One::EmailDirect::Facade.list_add(@credentials, @list2[:name], @list2[:description])
    One::EmailDirect::Facade.publication_add(@credentials, @publication1[:name], @publication1[:description])
    One::EmailDirect::Facade.publication_add(@credentials, @publication2[:name], @publication2[:description])

    @source1 = One::EmailDirect::Facade.source_get(@credentials, @source1[:name])
    @source2 = One::EmailDirect::Facade.source_get(@credentials, @source2[:name])

    @list1 = One::EmailDirect::Facade.list_get(@credentials, @list1[:name])
    @list2 = One::EmailDirect::Facade.list_get(@credentials, @list2[:name])

    @publication1 = One::EmailDirect::Facade.publication_get(@credentials, @publication1[:name])
    @publication2 = One::EmailDirect::Facade.publication_get(@credentials, @publication2[:name])

    @custom_fields1 = {
      'FirstName' => 'John',
      'LastName' => 'Doe',
      'Age' => 30
    }
    @custom_fields2 = {
      'FirstName' => 'Johny',
      'LastName' => 'Doey',
      'Age' => 31
    }

    @expected_custom_fields1 = [
      {:value => 'John',  :field_name => 'FirstName'},
      {:value => 'Doe',   :field_name => 'LastName'},
      {:value => '30',    :field_name => 'Age'}
    ]
    @expected_custom_fields2 = [
      {:value => 'Johny',  :field_name => 'FirstName'},
      {:value => 'Doey',   :field_name => 'LastName'},
      {:value => '31',    :field_name => 'Age'}
    ]
  end

  def teardown()
    One::EmailDirect::Facade.list_getall(@credentials).each {|element|
      One::EmailDirect::Facade.list_delete(@credentials, element[:element_id])
    }
    One::EmailDirect::Facade.publication_getall(@credentials).each {|element|
      One::EmailDirect::Facade.publication_delete(@credentials, element[:element_id])
    }
    One::EmailDirect::Facade.source_getall(@credentials).each {|element|
      One::EmailDirect::Facade.source_delete(@credentials, element[:element_id])
    }
    [@email1, @email2, @email3, @email4, @email5, @email6, @email7].each {|email|
      One::EmailDirect::Facade.email_delete(@credentials, email, false) rescue nil
    }
  end

  # Tests for One::EmailDirect::Facade.email_add.
  #
  # 1. create a new email
  # 1.1 specifying all parameters (one list and one publication)
  # 1.2 specifying all parameters (two lists and two publication)
  # 1.3 with no force parameter
  # 1.4 with no list
  # 1.5 with no list and publications
  # 1.6 with no email
  # 1.7 using a previously inserted email
  #
  def test_email_add()   
    # 1.1
    assert_nil One::EmailDirect::Facade.email_add(
        @credentials, @email1,
        @source1[:element_id], [@publication1[:element_id]], [@list1[:element_id]],
        @autoresponder, @force
    )


    # 1.2
    assert_nil One::EmailDirect::Facade.email_add(
        @credentials, @email2,
        @source1[:element_id], [@publication1[:element_id], @publication2[:element_id]], [@list1[:element_id], @list2[:element_id]],
        @autoresponder, @force
    )


    # 1.3
    assert_nil One::EmailDirect::Facade.email_add(
        @credentials, @email3,
        @source1[:element_id], [@publication1[:element_id]], [@list1[:element_id]],
        @autoresponder
    )


    # 1.4
    assert_nil One::EmailDirect::Facade.email_add(
        @credentials, @email4,
        @source1[:element_id], [@publication1[:element_id]], [],
        @autoresponder, @force
    )
    assert_nil One::EmailDirect::Facade.email_add(
        @credentials, @email5,
        @source1[:element_id], [@publication1[:element_id]], nil,
        @autoresponder, @force
    )


    # 1.5
    assert_nil One::EmailDirect::Facade.email_add(
        @credentials, @email6,
        @source1[:element_id], [], [@list1[:element_id]],
        @autoresponder, @force
    )
    assert_nil One::EmailDirect::Facade.email_add(
        @credentials, @email7,
        @source1[:element_id], nil, [@list1[:element_id]],
        @autoresponder, @force
    )


    # 1.6
    assert_raises StandardError do
      One::EmailDirect::Facade.email_add(
        @credentials, nil,
        @source1[:element_id], [@publication1[:element_id]], [@list1[:element_id]],
        @autoresponder
      )
    end


    # 1.7
    assert_nil One::EmailDirect::Facade.email_add(
      @credentials, @email1,
      @source1[:element_id], [@publication1[:element_id]], [@list1[:element_id]],
      @autoresponder, @force
    )
  end

  def clean_email_getproperties(result)
    result.delete(:create_date)
    result.delete(:date_stamp)
    result.delete(:ip_address)
    result.delete(:email_id)
    cleaned_custom_fields = []
    result[:custom_fields][:custom_field].each { |element|
      cleaned_custom_fields << element if !element[:field_name].eql? 'DateStamp' and !element[:field_name].eql? 'IPAddress'
    }
    result[:custom_fields][:custom_field] = cleaned_custom_fields
    return result
  end


  # Tests for One::EmailDirect::Facade.email_add_with_fields.
  #
  # 1. create a new email
  # 1.1 specifying all parameters (one list and one publication)
  # 1.2 specifying all parameters (two lists and two publication)
  # 1.3 with no list
  # 1.4 with no publications
  # 1.5 with no email
  # 1.6 using a previously inserted email
  #
  def test_email_addwithfields()
    # 1.1
    assert_nil One::EmailDirect::Facade.email_addwithfields(
        @credentials, @email1,
        @source1[:element_id],
        [@publication1[:element_id]], [@list1[:element_id]],
        @autoresponder, @force,
        @custom_fields1
    )

    result = clean_email_getproperties(
        One::EmailDirect::Facade.email_getproperties(
          @credentials, @email1
        )
    )
    expected = {
     :status => 'Active',
     :publications => {:element => @publication1},
     :lists => {:element => @list1},
     :email => @email1,
     :custom_fields => {:custom_field => @expected_custom_fields1},
     :source => @source1
    }
    expected[:custom_fields][:custom_field] = [{:value => @email1, :field_name => 'Email'}] + expected[:custom_fields][:custom_field]
    assert_equal expected, result


    # 1.2
    assert_nil One::EmailDirect::Facade.email_addwithfields(
        @credentials, @email2,
        @source1[:element_id],
        [@publication1[:element_id], @publication2[:element_id]],
        [@list1[:element_id], @list2[:element_id]],
        @autoresponder, @force,
        @custom_fields1
    )

    result = clean_email_getproperties(
        One::EmailDirect::Facade.email_getproperties(
          @credentials, @email2
        )
    )
    expected = {
     :status => 'Active',
     :publications => {:element => [@publication1, @publication2]},
     :lists => {:element => [@list1, @list2]},
     :email => @email2,
     :custom_fields => {:custom_field => @expected_custom_fields1},
     :source => @source1
    }
    expected[:custom_fields][:custom_field] = [{:value => @email2, :field_name => 'Email'}] + expected[:custom_fields][:custom_field]
    assert_equal expected, result


    # 1.3.1
    puts "@email3=#{@email3}"
    assert_nil One::EmailDirect::Facade.email_addwithfields(
        @credentials, @email3,
        @source1[:element_id],
        [@publication1[:element_id]], [],
        @autoresponder, @force,
        @custom_fields1
    )

    result = clean_email_getproperties(
        One::EmailDirect::Facade.email_getproperties(
          @credentials, @email3
        )
    )
    expected = {
     :status => 'Active',
     :publications => {:element => @publication1},
     :lists => nil,
     :email => @email3,
     :custom_fields => {:custom_field => @expected_custom_fields1},
     :source => @source1
    }
    expected[:custom_fields][:custom_field] = [{:value => @email3, :field_name => 'Email'}] + expected[:custom_fields][:custom_field]
    assert_equal expected, result


    # 1.3.2
    assert_nil One::EmailDirect::Facade.email_addwithfields(
        @credentials, @email4,
        @source1[:element_id], [@publication1[:element_id]], nil,
        @autoresponder, @force,
        @custom_fields1
    )

    result = clean_email_getproperties(
        One::EmailDirect::Facade.email_getproperties(
          @credentials, @email4
        )
    )
    expected = {
     :status => 'Active',
     :publications => {:element => @publication1},
     :lists => nil,
     :email => @email4,
     :custom_fields => {:custom_field => @expected_custom_fields1},
     :source => @source1
    }
    expected[:custom_fields][:custom_field] = [{:value => @email4, :field_name => 'Email'}] + expected[:custom_fields][:custom_field]
    assert_equal expected, result


    # 1.4.1
    assert_nil One::EmailDirect::Facade.email_addwithfields(
        @credentials, @email5,
        @source1[:element_id], [], [@list1[:element_id]],
        @autoresponder, @force,
        @custom_fields1
    )

    result = clean_email_getproperties(
        One::EmailDirect::Facade.email_getproperties(
          @credentials, @email5
        )
    )
    expected = {
     :status => 'Active',
     :publications => nil,
     :lists => {:element => @list1},
     :email => @email5,
     :custom_fields => {:custom_field => @expected_custom_fields1},
     :source => @source1
    }
    expected[:custom_fields][:custom_field] = [{:value => @email5, :field_name => 'Email'}] + expected[:custom_fields][:custom_field]
    assert_equal expected, result


    # 1.4.2
    assert_nil One::EmailDirect::Facade.email_addwithfields(
        @credentials, @email6,
        @source1[:element_id], nil, [@list1[:element_id]],
        @autoresponder, @force,
        @custom_fields1
    )

    result = clean_email_getproperties(
        One::EmailDirect::Facade.email_getproperties(
          @credentials, @email6
        )
    )
    expected = {
     :status => 'Active',
     :publications => nil,
     :lists => {:element => @list1},
     :email => @email6,
     :custom_fields => {:custom_field => @expected_custom_fields1},
     :source => @source1
    }
    expected[:custom_fields][:custom_field] = [{:value => @email6, :field_name => 'Email'}] + expected[:custom_fields][:custom_field]
    assert_equal expected, result


    # 1.5
    assert_raises StandardError do
      One::EmailDirect::Facade.email_addwithfields(
        @credentials, nil,
        @source1[:element_id], [@publication1[:element_id]], [@list1[:element_id]],
        @autoresponder, @force,
        @custom_fields1
      )
    end


    # 1.6.1 using the exact same lists and publications
    assert_nil One::EmailDirect::Facade.email_addwithfields(
      @credentials, @email1,
      @source1[:element_id], [@publication1[:element_id]], [@list1[:element_id]],
      @autoresponder, @force,
      @custom_fields1
    )

    result = clean_email_getproperties(
        One::EmailDirect::Facade.email_getproperties(
          @credentials, @email1
        )
    )
    expected = {
     :status => 'Active',
     :publications => {:element => @publication1},
     :lists => {:element => @list1},
     :email => @email1,
     :custom_fields => {:custom_field => @expected_custom_fields1},
     :source => @source1
    }
    expected[:custom_fields][:custom_field] = [{:value => @email1, :field_name => 'Email'}] + expected[:custom_fields][:custom_field]
    assert_equal expected, result


    # 1.6.2 using different lists, publications and custom fields
    assert_nil One::EmailDirect::Facade.email_addwithfields(
      @credentials, @email1,
      @source1[:element_id], [@publication2[:element_id]], [@list2[:element_id]],
      @autoresponder, @force,
      @custom_fields2
    )

    result = clean_email_getproperties(
        One::EmailDirect::Facade.email_getproperties(
          @credentials, @email1
        )
    )
    expected = {
     :status => 'Active',
     :publications => {:element => [@publication1, @publication2]},
     :lists => {:element => [@list1, @list2]},
     :email => @email1,
     :custom_fields => {:custom_field => @expected_custom_fields2},
     :source => @source1
    }
    expected[:custom_fields][:custom_field] = [{:value => @email1, :field_name => 'Email'}] + expected[:custom_fields][:custom_field]
    assert_equal expected, result
  end



  # Tests for One::EmailDirect::Facade.email_getproperties.
  #
  # 1. use an email not registered in the account
  #
  def test_email_getproperties()

    # 1.
    assert_raises StandardError do
      One::EmailDirect::Facade.email_getproperties(
        @credentials, @email1
      )
    end
  end

end
