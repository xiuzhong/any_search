require_relative "data_store"

class SearchService
  def perform(raw_query)
    raise(ArgumentError, "invalid query") unless raw_query.is_a?(String)

    query = raw_query.strip
    raise(ArgumentError, "query cannot be empty") if query.empty?

    result = DataStore.instance.search_by_partial_name(query)
  end
end