require "#{File.dirname(__FILE__)}/../helpers/requires"



class TestListFacade < Test::Unit::TestCase

  def setup()
    config = Steenzout::ConfigurationManager.configuration_for_gem :'one-emaildirect'
    @credentials = One::EmailDirect::Credentials.create_from config

    generator = UUID.new()

    uuid1 = generator.generate(:compact)
    @list_add = {:name => "name#{uuid1}", :description => "description#{uuid1}"}


    uuid2 = generator.generate(:compact)
    @list_getall1 = {:name => "name#{uuid2}", :description => "description#{uuid2}"}

    uuid3 = generator.generate(:compact)
    @list_getall2 = {:name => "name#{uuid3}", :description => "description#{uuid3}"}

    uuid4 = generator.generate(:compact)
    @list_getall3 = {:name => "name#{uuid4}", :description => "description#{uuid4}"}


    uuid5 = generator.generate(:compact)
    @list_get = {:name => "name#{uuid5}", :description => "description#{uuid5}"}
  end

  def teardown()
    One::EmailDirect::Facade.list_getall(@credentials).each {|element|
      One::EmailDirect::Facade.list_delete(@credentials, element[:element_id])
    }
  end

  def get_single_list(list_name)
    One::EmailDirect::Facade.list_getall(@credentials).each {|element|
      return element if element[:element_name] == list_name
    }
    nil
  end


  # Tests for One::EmailDirect::Facade.list_add.
  #
  # 1. create a new list
  # 2. create a new list with a previously used name
  #
  def test_list_add()
    # 1. create a new list
    One::EmailDirect::Facade.list_add(@credentials, @list_add[:name], @list_add[:description])
    result = get_single_list(@list_add[:name])
    expected = {
        :element_name => @list_add[:name],
        :description => @list_add[:description]
    }

    assert_not_nil result
    result.delete(:element_id)
    assert_equal expected, result


    # 2. create a new list with a previously used name
    assert_raises StandardError do
      One::EmailDirect::Facade.list_add(@credentials, @list_add[:name], @list_add[:description])
    end
  end



  # Tests for One::EmailDirect::Facade.list_get.
  #
  # 1. using an existing list
  # 2. using an inexistent list
  #
  def test_list_get()
    One::EmailDirect::Facade.list_add(@credentials, @list_get[:name], @list_get[:description])


    # 1.
    result = One::EmailDirect::Facade.list_get(@credentials, @list_get[:name])
    assert result.has_key? :element_id
    assert result.has_key? :element_name
    assert result.has_key? :description
    result.delete(:element_id)
    expected = {
        :element_name => @list_get[:name],
        :description => @list_get[:description]
    }
    assert_equal expected, result


    # 2.
    assert_nil One::EmailDirect::Facade.list_get(@credentials, 'inexistent')
  end



  # Tests for One::EmailDirect::Facade.list_getall.
  #
  # 1. no lists
  # 2. one list
  # 3. two lists
  # 4. three lists
  #
  def test_list_getall()
    # 1. no lists
    assert_equal [], One::EmailDirect::Facade.list_getall(@credentials)


    # 2. one list
    One::EmailDirect::Facade.list_add(@credentials, @list_getall1[:name], @list_getall1[:description])
    result = One::EmailDirect::Facade.list_getall(@credentials)
    expected = [{
        :element_name => @list_getall1[:name],
        :description => @list_getall1[:description]
    }]
    result.collect! {|element| element.delete(:element_id); element} # remove ids
    assert_equal expected, result


    # 3. two lists
    One::EmailDirect::Facade.list_add(@credentials, @list_getall2[:name], @list_getall2[:description])
    result = One::EmailDirect::Facade.list_getall(@credentials)
    expected = [{
        :element_name => @list_getall1[:name],
        :description => @list_getall1[:description]
    }, {
        :element_name => @list_getall2[:name],
        :description => @list_getall2[:description]
    }]
    result.collect! {|element| element.delete(:element_id); element} # remove ids
    assert_equal expected, result


    # 4. three lists
    One::EmailDirect::Facade.list_add(@credentials, @list_getall3[:name], @list_getall3[:description])
    result = One::EmailDirect::Facade.list_getall(@credentials)
    expected = [{
        :element_name => @list_getall1[:name],
        :description => @list_getall1[:description]
    }, {
        :element_name => @list_getall2[:name],
        :description => @list_getall2[:description]
    }, {
        :element_name => @list_getall3[:name],
        :description => @list_getall3[:description]
    }]
    result.collect! {|element| element.delete(:element_id); element} # remove ids
    assert_equal expected, result
  end

end
