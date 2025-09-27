require "singleton"
require_relative "client"

class DataStore
  include Singleton

  def initialize
    @clients = []
    @clients_index_by_email = {}
  end

  def store(client)
    return unless client && client.is_a?(Client)

    @clients << client
    @clients_index_by_email[client.email] ||= []
    @clients_index_by_email[client.email] << client
  end

  def search_by_partial_name(partial_name)
    @clients.select { |c| c.full_name.include?(partial_name) }
  end

  def find_duplicate_emails
    @clients_index_by_email.select { |_k, v| v.size > 1 }
  end

  # for test only
  def clear
    @clients = []
    @clients_index_by_email = {}
  end
end