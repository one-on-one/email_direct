require "#{File.dirname(__FILE__)}/../helpers/requires"



class TestSourceFacade < Test::Unit::TestCase

  def setup()
    config = Steenzout::ConfigurationManager.configuration_for_gem :'one-emaildirect'
    @credentials = One::EmailDirect::Credentials.create_from config

    generator = UUID.new()
    uuid1 = generator.generate(:compact)
    @source_add = {:name => "name#{uuid1}", :description => "description#{uuid1}"}


    uuid2 = generator.generate(:compact)
    @source_getall1 = {:name => "name#{uuid2}", :description => "description#{uuid2}"}

    uuid3 = generator.generate(:compact)
    @source_getall2 = {:name => "name#{uuid3}", :description => "description#{uuid3}"}

    uuid4 = generator.generate(:compact)
    @source_getall3 = {:name => "name#{uuid4}", :description => "description#{uuid4}"}


    uuid5 = generator.generate(:compact)
    @source_get = {:name => "name#{uuid5}", :description => "description#{uuid5}"}
  end

  def teardown()
    One::EmailDirect::Facade.source_getall(@credentials).each {|element|
      One::EmailDirect::Facade.source_delete(@credentials, element[:element_id])
    }
  end

  def get_single_source(source_name)
    One::EmailDirect::Facade.source_getall(@credentials).each {|element|
      return element if element[:element_name] == source_name
    }
    nil
  end


  # Tests for One::EmailDirect::Facade.source_add.
  #
  # 1. create a new source
  # 2. create a new source with a previously used name
  #
  def test_source_add()
    # 1. create a new source
    One::EmailDirect::Facade.source_add(@credentials, @source_add[:name], @source_add[:description])
    result = get_single_source(@source_add[:name])
    expected = {
        :element_name => @source_add[:name],
        :description => @source_add[:description]
    }

    assert_not_nil result
    result.delete(:element_id)
    assert_equal expected, result


    # 2. create a new source with a previously used name
    assert_raises One::EmailDirect::EmailDirectException do
      One::EmailDirect::Facade.source_add(@credentials, @source_add[:name], @source_add[:description])
    end
  end



  # Tests for One::EmailDirect::Facade.source_get.
  #
  # 1. using an existing source
  # 2. using an inexistent source
  #
  def test_source_get()
    One::EmailDirect::Facade.source_add(@credentials, @source_get[:name], @source_get[:description])


    # 1.
    result = One::EmailDirect::Facade.source_get(@credentials, @source_get[:name])
    assert result.has_key? :element_id
    assert result.has_key? :element_name
    assert result.has_key? :description
    result.delete(:element_id)
    expected = {
        :element_name => @source_get[:name],
        :description => @source_get[:description]
    }
    assert_equal expected, result


    # 2.
    assert_nil One::EmailDirect::Facade.source_get(@credentials, 'inexistent')
  end



  # Tests for One::EmailDirect::Facade.source_getall.
  #
  # 1. no sources
  # 2. one source
  # 3. two sources
  # 4. three sources
  #
  def test_source_getall()
    # 1. no sources
    assert_equal [], One::EmailDirect::Facade.source_getall(@credentials)


    # 2. one source
    One::EmailDirect::Facade.source_add(@credentials, @source_getall1[:name], @source_getall1[:description])
    result = One::EmailDirect::Facade.source_getall(@credentials)
    expected = [{
        :element_name => @source_getall1[:name],
        :description => @source_getall1[:description]
    }]
    result.collect! {|element| element.delete(:element_id); element} # remove ids
    assert_equal expected, result


    # 3. two sources
    One::EmailDirect::Facade.source_add(@credentials, @source_getall2[:name], @source_getall2[:description])
    result = One::EmailDirect::Facade.source_getall(@credentials)
    expected = [{
        :element_name => @source_getall1[:name],
        :description => @source_getall1[:description]
    }, {
        :element_name => @source_getall2[:name],
        :description => @source_getall2[:description]
    }]
    result.collect! {|element| element.delete(:element_id); element} # remove ids
    assert_equal expected, result


    # 4. three sources
    One::EmailDirect::Facade.source_add(@credentials, @source_getall3[:name], @source_getall3[:description])
    result = One::EmailDirect::Facade.source_getall(@credentials)
    expected = [{
        :element_name => @source_getall1[:name],
        :description => @source_getall1[:description]
    }, {
        :element_name => @source_getall2[:name],
        :description => @source_getall2[:description]
    }, {
        :element_name => @source_getall3[:name],
        :description => @source_getall3[:description]
    }]
    result.collect! {|element| element.delete(:element_id); element} # remove ids
    assert_equal expected, result
  end

end
