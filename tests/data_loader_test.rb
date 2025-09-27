require "test/unit"
require "tempfile"
require_relative "../src/data_loader"

class DataLoaderTest < Test::Unit::TestCase
  def setup
    @file = Tempfile.new("DataLoaderTest")
    DataStore.instance.clear
  end

  def teardown
    @file.unlink
  end

  def test_valid_client
    @file.write([{ "id": 1, "full_name": "John Doe", "email": "john.doe@gmail.com" }].to_json)
    @file.rewind

    assert_equal [], DataLoader.load(@file.path)
    assert_equal 1, DataStore.instance.size
  end

  def test_invalid_client
    @file.write([{ "id": 1, "full_name": " ", "email": "john@gmail.com" }].to_json)
    @file.rewind

    assert_equal [{ "id" => 1, "full_name" => " ", "email" => "john@gmail.com" }], DataLoader.load(@file.path)
    assert_equal 0, DataStore.instance.size
  end

  def test_valid_and_invalid_clients
    @file.write([
      { "id": 1, "full_name": " ", "email": "john@gmail.com" },
      { "id": 2, "full_name": "Ryan", "email": "ryan@gmail.com" },
    ].to_json)
    @file.rewind

    assert_equal [{ "id" => 1, "full_name" => " ", "email" => "john@gmail.com" }], DataLoader.load(@file.path)
    assert_equal 1, DataStore.instance.size
  end

  def test_invalid_file_path
    assert_raise_kind_of(SystemCallError) do
      DataLoader.load("/doesnt-exist")
    end
  end

  def test_invalid_json
    @file.write("invalid json structure")
    @file.rewind

    assert_raise JSON::ParserError do
      DataLoader.load(@file.path)
    end
  end
end