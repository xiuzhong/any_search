require "json"
require_relative "client"
require_relative "data_store"

class DataLoader
  def self.load(file_path)
    json_data = File.read(file_path)

    JSON.parse(json_data).each_with_object([]) do |client_data, invalid|
      begin
        client = Client.new(
          client_data["id"],
          client_data["full_name"],
          client_data["email"]
        )

        DataStore.instance.store(client)
      rescue ArgumentError
        invalid << client_data
      end
    end
  end
end
