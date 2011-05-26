require "#{File.dirname(__FILE__)}/../helpers/requires"



class TestPublicationFacade < Test::Unit::TestCase

  def setup()
    config = Steenzout::ConfigurationManager.configuration_for_gem :'one-emaildirect'
    @credentials = One::EmailDirect::Credentials.create_from config

    generator = UUID.new()
    uuid1 = generator.generate(:compact)
    @publication_add = {:name => "name#{uuid1}", :description => "description#{uuid1}"}


    uuid2 = generator.generate(:compact)
    @publication_getall1 = {:name => "name#{uuid2}", :description => "description#{uuid2}"}

    uuid3 = generator.generate(:compact)
    @publication_getall2 = {:name => "name#{uuid3}", :description => "description#{uuid3}"}

    uuid4 = generator.generate(:compact)
    @publication_getall3 = {:name => "name#{uuid4}", :description => "description#{uuid4}"}

    uuid5 = generator.generate(:compact)
    @publication_get1 = {:name => "name#{uuid5}", :description => "description#{uuid5}"}
  end

  def teardown()
    One::EmailDirect::Facade.publication_getall(@credentials).each {|element|
      One::EmailDirect::Facade.publication_delete(@credentials, element[:element_id])
    }
  end

  def get_single_publication(publication_name)
    One::EmailDirect::Facade.publication_getall(@credentials).each {|element|
      return element if element[:element_name] == publication_name
    }
    nil
  end


  # Tests for One::EmailDirect::Facade.publication_add.
  #
  # 1. create a new publication
  # 2. create a new publication with a previously used name
  #
  def test_publication_add()
    # 1. create a new publication
    One::EmailDirect::Facade.publication_add(@credentials, @publication_add[:name], @publication_add[:description])
    result = get_single_publication(@publication_add[:name])
    expected = {
        :element_name => @publication_add[:name],
        :description => @publication_add[:description]
    }

    assert_not_nil result
    result.delete(:element_id)
    assert_equal expected, result


    # 2. create a new publication with a previously used name
    assert_raises One::EmailDirect::EmailDirectException do
      One::EmailDirect::Facade.publication_add(@credentials, @publication_add[:name], @publication_add[:description])
    end
  end



  # Tests for One::EmailDirect::Facade.publication_get.
  #
  # 1. using an existing publication
  # 2. using an inexistent publication
  #
  def test_publication_get()
    One::EmailDirect::Facade.publication_add(@credentials, @publication_get1[:name], @publication_get1[:description])


    # 1.
    result = One::EmailDirect::Facade.publication_get(@credentials, @publication_get1[:name])
    assert result.has_key? :element_id
    assert result.has_key? :element_name
    assert result.has_key? :description
    result.delete(:element_id)
    expected = {
        :element_name => @publication_get1[:name],
        :description => @publication_get1[:description]
    }
    assert_equal expected, result


    # 2.
    assert_nil One::EmailDirect::Facade.publication_get(@credentials, 'inexistent')
  end


  # Tests for One::EmailDirect::Facade.publication_getall.
  #
  # 1. no publications
  # 2. one publication
  # 3. two publications
  # 4. three publications
  #
  def test_publication_getall()
    # 1. no publications
    assert_equal [], One::EmailDirect::Facade.publication_getall(@credentials)


    # 2. one publication
    One::EmailDirect::Facade.publication_add(@credentials, @publication_getall1[:name], @publication_getall1[:description])
    result = One::EmailDirect::Facade.publication_getall(@credentials)
    expected = [{
        :element_name => @publication_getall1[:name],
        :description => @publication_getall1[:description]
    }]
    result.collect! {|element| element.delete(:element_id); element} # remove ids
    assert_equal expected, result


    # 3. two publications
    One::EmailDirect::Facade.publication_add(@credentials, @publication_getall2[:name], @publication_getall2[:description])
    result = One::EmailDirect::Facade.publication_getall(@credentials)
    expected = [{
        :element_name => @publication_getall1[:name],
        :description => @publication_getall1[:description]
    }, {
        :element_name => @publication_getall2[:name],
        :description => @publication_getall2[:description]
    }]
    result.collect! {|element| element.delete(:element_id); element} # remove ids
    assert_equal expected, result


    # 4. three publications
    One::EmailDirect::Facade.publication_add(@credentials, @publication_getall3[:name], @publication_getall3[:description])
    result = One::EmailDirect::Facade.publication_getall(@credentials)
    expected = [{
        :element_name => @publication_getall1[:name],
        :description => @publication_getall1[:description]
    }, {
        :element_name => @publication_getall2[:name],
        :description => @publication_getall2[:description]
    }, {
        :element_name => @publication_getall3[:name],
        :description => @publication_getall3[:description]
    }]
    result.collect! {|element| element.delete(:element_id); element} # remove ids
    assert_equal expected, result
  end

end
