#!/usr/bin/env ruby

require "optparse"
require_relative "src/data_loader"
require_relative "src/search_service"
require_relative "src/find_duplicate_service"

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: app.rb [options]"

  opts.on("-f", "--file PATH", "Path to JSON file") do |v|
    options[:file] = v
  end

  opts.on("-s", "--search QUERY", "Search email") do |query|
    options[:search] = { query: query }
  end

  opts.on("-d", "--duplicates", "Find duplicate emails") do
    options[:duplicates] = true
  end

  opts.on("-h", "--help", "Prints this help") do
    puts opts
    exit
  end
end.parse!

if options[:file].nil? || options[:file].strip.empty?
  puts "File cannot be empty"
  exit 1
end

if options[:search].nil? && options[:duplicates].nil?
  puts "! No action is given"
  exit 1
end

invalid_records = DataLoader.load(options[:file])
unless invalid_records.empty?
  puts "\nINVALID CLIENTS:"
  puts "----------------------------"
  pp invalid_records
  puts "----------------------------"
end

puts "\nOUTPUT:"
puts "----------------------------"
if options[:search]
  results = SearchService.new.perform(options[:search][:query])
  pretty_results = results.map(&:to_h)
elsif options[:duplicates]
  results = FindDuplicateService.new.perform
  pretty_results = results.map { |k, v| [k, v.map(&:to_h)] }.to_h
end
pp pretty_results
puts "----------------------------"
