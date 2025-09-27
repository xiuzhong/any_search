require "test/unit"
require_relative "../src/search_service"

class SearchServiceTest < Test::Unit::TestCase
  def test_query_is_nil
    assert_raise_with_message(ArgumentError, "invalid query") do
      SearchService.new.perform(nil)
    end
  end

  def test_query_is_empty
    assert_raise_with_message(ArgumentError, "query cannot be empty") do
      SearchService.new.perform(" ")
    end
  end

  def test_query_is_valid
    assert_nothing_raised do
      assert_equal [], SearchService.new.perform("Ryan")
    end
  end
end