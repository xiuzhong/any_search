require_relative "data_store"

class FindDuplicateService
  def perform
    DataStore.instance.find_duplicate_emails
  end
end