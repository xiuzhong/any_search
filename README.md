# any_search

Demo of search dataset by any field

## Setup

Ruby is the only dependency, check and install Ruby in your local machine.

## Usage

- `git clone https://github.com/xiuzhong/any_search.git`
- `cd any_search`
- `app.rb -h`

```shell
main > ./app.rb -h
Usage: app.rb [options]
    -f, --file PATH                  Path to JSON file
    -s, --search QUERY               Search email
    -d, --duplicates                 Find duplicate emails
    -h, --help                       Prints this help
```

## Test

```shell
main > ruby tests/test.rb
```


### Example

```shell
# Search by matching name
main > ./app.rb -f data/clients.json -s "Jane"

OUTPUT:
----------------------------
[{id: 2, full_name: "Jane Smith", email: "jane.smith@yahoo.com"},
 {id: 15, full_name: "Another Jane Smith", email: "jane.smith@yahoo.com"}]
----------------------------

# Find clients with duplicated emails
main > ./app.rb -f data/clients.json -d

OUTPUT:
----------------------------
{"jane.smith@yahoo.com" =>
  [{id: 2, full_name: "Jane Smith", email: "jane.smith@yahoo.com"},
   {id: 15, full_name: "Another Jane Smith", email: "jane.smith@yahoo.com"}]}
----------------------------

# Print out invalid clients if there is
main > ./app.rb -f data/clients_invalid.json -s "Jane"

INVALID CLIENTS:
----------------------------
[{"id" => 1, "full_name" => " ", "email" => "john.doe@gmail.com"}, {"id" => 6, "full_name" => "William Davis", "email" => ""}]
----------------------------

OUTPUT:
----------------------------
[{id: 2, full_name: "Jane Smith", email: "jane.smith@yahoo.com"},
 {id: 15, full_name: "Another Jane Smith", email: "jane.smith@yahoo.com"}]
----------------------------
```

## Design

The app is structured in MVC (Model, View, Controller) architecture:

- Model: Client, DataStore and DataLoader
- Controller: SearchService and FindDuplicateService
- View: the CLI app

## Assumptions and decisions made

- Only Ruby built-in libraries is used. No 3rd party gems and framework are used given this is a demo project. For the same reason, I haven't brought into any static code analyzer, code formatter and security vulnerabilities checker.
- The src folder is flat given there're only 5 files. Over time it could be organized either by layers (MVC layers), or by business concerns.
- The json file is not too large to blow memory. So the DataLoader can read the whole file into memory, and JSON parser parse it as a whole. Streaming support (both the File IO streaming and JSON parse streaming) should be considered if the file is really large.
- Assume the JSON file is an array of hashes, each hash has client attributes which may be invalid. In which cases the CLI should print out the invalid hashes, and handle valid hashes correctly.
- The full_name and searching by full_name is case-sensitive
- The search sequentially scans the whole array of clients in one thread, and may perform worse when the store has a large amount of records. It can be improved by:
  - Sharding the store: run multiple store instances in multiple processes, so the search can be done in parallel.
  - Use database to persist data
- The email is case-insensitive
- The email duplication detection is based on Hash which may perform worse when the store is large. Similar ideas (sharding or database) can be used to improve performance.
- Client is a simple Struct because there aren't too many functions. Over time it may evolve to something like ActiveModel.
- the CLI `app.rb` isn't covered by any test because of the limit of time, and testing standand output is tedious. If this CLI app is enhanced with more features, proper unit or system tests should be implemented.

## Improvements

### Features

- Searching by email, searching by both (full_name and email), and searching by Regex would be great to add.
- Given an email, return all duplicates.

### Performance & Scalability

- Sharding and running stores on multiple CPUs are interesting, but using a database is more pragmatic.
- Full name searching has to use `String.include?` and sequential scan because the pattern match can occur at any position of full name. As contrasted with it, searching full name starting with a pattern would be more efficient and can be further optimised by using some sort of index (like B-tree). So clarifying the requirement and distinguishing use cases (including vs exact matching vs starting with) if possible, so the implementation can optimise each use cases respectively.
- Using cache for full name searching doesn't apply to CLI (it's one-off run) but is great to consider if this is a server app supporting APIs.
- Support File Streaming and JSON parse streaming for large JSON file.
