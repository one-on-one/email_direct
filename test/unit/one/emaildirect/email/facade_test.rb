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

    @source1 = @source1.clone
    @source2 = @source2.clone

    @email1 = '%s@1on1.com' % [uuid1]
    @email2 = '%s@1on1.com' % [uuid2]
    @email2 = '%s@1on1.com' % [generator.generate(:compact)]
    @email3 = '%s@1on1.com' % [generator.generate(:compact)]
    @email4 = '%s@1on1.com' % [generator.generate(:compact)]
    @email5 = '%s@1on1.com' % [generator.generate(:compact)]
    @email6 = '%s@1on1.com' % [generator.generate(:compact)]
    @email7 = '%s@1on1.com' % [generator.generate(:compact)]

    @autoresponder = 0
    @force = false


    # create test resources
    One::EmailDirect::Facade.source_add(@credentials, @source[:name], @source[:description])
    One::EmailDirect::Facade.list_add(@credentials, @list1[:name], @list1[:description])
    One::EmailDirect::Facade.list_add(@credentials, @list2[:name], @list2[:description])
    One::EmailDirect::Facade.publication_add(@credentials, @publication1[:name], @publication1[:description])
    One::EmailDirect::Facade.publication_add(@credentials, @publication2[:name], @publication2[:description])
  end

  def teardown()
    One::EmailDirect::Facade.list_get_all(@credentials).each {|element|
      One::EmailDirect::Facade.list_delete(@credentials, element[:element_id])
    }
    One::EmailDirect::Facade.publication_get_all(@credentials).each {|element|
      One::EmailDirect::Facade.publication_delete(@credentials, element[:element_id])
    }
    One::EmailDirect::Facade.source_get_all(@credentials).each {|element|
      One::EmailDirect::Facade.source_delete(@credentials, element[:element_id])
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
        @credentials, @email1, @source1, [@publication1], [@list1], @autoresponder, @force
    )


    # 1.2
    assert_nil One::EmailDirect::Facade.email_add(
        @credentials, @email2, @source1, [@publication1, @publication2], [@list1, @list2], @autoresponder, @force
    )


    # 1.3
    assert_nil One::EmailDirect::Facade.email_add(
        @credentials, @email3, @source1, [@publication1], [@list1], @autoresponder
    )


    # 1.4
    assert_nil One::EmailDirect::Facade.email_add(
        @credentials, @email4, @source1, [@publication1], [], @autoresponder, @force
    )
    assert_nil One::EmailDirect::Facade.email_add(
        @credentials, @email5, @source1, [@publication1], nil, @autoresponder, @force
    )


    # 1.5
    assert_nil One::EmailDirect::Facade.email_add(
        @credentials, @email6, @source1, [], [@list1], @autoresponder, @force
    )
    assert_nil One::EmailDirect::Facade.email_add(
        @credentials, @email7, @source1, nil, [@list1], @autoresponder, @force
    )


    # 1.6
    assert_nil One::EmailDirect::Facade.email_add(
        @credentials, nil, @source1, [@publication1], [@list1], @autoresponder
    )


    # 1.7
    assert_equal [], One::EmailDirect::Facade.email_add(
        @credentials, @email1, @source1, [@publication1], [@list1], @autoresponder, @force
    )
  end

end
