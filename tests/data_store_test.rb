require "test/unit"
require_relative "../src/data_store"

class EmptyDataStoreTest < Test::Unit::TestCase
  def setup
    DataStore.instance.clear
  end

  def test_empty_store
    assert_equal([], DataStore.instance.search_by_partial_name("Smith"))
    assert_equal({}, DataStore.instance.find_duplicate_emails)
  end
end

class DataStoreTest < Test::Unit::TestCase
  def setup
    DataStore.instance.clear
    @john = Client.new(1, "John Doe", "john.doe@gmail.com")
    @another_john = Client.new(2, "Another John Doe", "john.doe@gmail.com")
    @jane = Client.new(3, "Jane Smith", "jane.smith@yahoo.com")

    [@john, @another_john, @jane].each do |client|
      DataStore.instance.store client
    end
  end

  def test_store_nil_client
    assert_nothing_raised do
      DataStore.instance.store(nil)
      assert_equal([@jane], DataStore.instance.search_by_partial_name("Jane"))
    end
  end

  def test_store_invalid_client
    assert_nothing_raised do
      DataStore.instance.store({"id": 5, "full_name": "Ryan", "email": "ryan@gmail.com"})
      assert_equal([], DataStore.instance.search_by_partial_name("Ryan"))
    end
  end

  def test_search_by_partial_name_nil
    assert_raise(TypeError) do
      DataStore.instance.search_by_partial_name(nil)
    end
  end

  def test_search_by_partial_name
    assert_equal([@john, @another_john], DataStore.instance.search_by_partial_name("John"))
  end

  def test_find_duplicate_emails
    duplicates =

    assert_equal(
      { "john.doe@gmail.com" => [@john, @another_john] },
      DataStore.instance.find_duplicate_emails
    )
  end
end