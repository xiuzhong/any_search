require "test/unit"
require_relative "../src/client"

class ClientTest < Test::Unit::TestCase
  def test_valid
    assert_nothing_raised do
      Client.new(11, "Smith", "email")
    end
  end

  def test_nil_id
    assert_raise_with_message(ArgumentError, "id is invalid") do
      Client.new(nil, "Smith", "smith@g.com")
    end
  end

  def test_nil_email
    assert_raise_with_message(ArgumentError, "email is invalid") do
      Client.new(11, "Smith", nil)
    end
  end

  def test_empty_email
    assert_raise_with_message(ArgumentError, "email cannot be empty") do
      Client.new(11, "Smith", " ")
    end
  end

  def test_nil_full_name
    assert_raise_with_message(ArgumentError, "full_name is invalid") do
      Client.new(11, nil, "Smith")
    end
  end

  def test_empty_full_name
    assert_raise_with_message(ArgumentError, "full_name cannot be empty") do
      Client.new(11, "  ", "email")
    end
  end
end