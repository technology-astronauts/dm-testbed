
# --------------------------------------------------------------------- database

require 'dm-core'
require 'dm-aggregates'
require 'dm-constraints'
require 'dm-migrations'
require 'dm-transactions'
require 'dm-serializer'
require 'dm-timestamps'
require 'dm-validations'

db_url = 'postgres://localhost/testbed'
DataMapper::Logger.new($stderr, :debug)
DataMapper.setup(:default, db_url)

require 'db/models'

# Not the droids you're looking for.
#
# Really. What this does is modify the adapter concerned (OracleAdapter) that 
# we use for PostgreSQL to drop tables using the keyword 'cascade'. This means
# that no matter what order we drop the tables in, they will always get dropped. 
# Otherwise one would need to do a topological sort of the tables first, and 
# I really don't feel like it right now. 
#
module DataMapper
  module Migrations
    module OracleAdapter
      def drop_table_statement(model)
        table_name = quote_name(model.storage_name(name))
        "DROP TABLE #{table_name} CASCADE"
      end
    end
  end
end

DataMapper.auto_migrate!

# ------------------------------------------------------------------------ rspec
RSpec.configure do |rspec|
  rspec.mock_with :flexmock

  require 'database_cleaner'
  DatabaseCleaner.strategy = :transaction
  rspec.around(:each) do |example|
    DatabaseCleaner.start
    example.run
    DatabaseCleaner.clean
  end
end

# ----------------------- where would I be without a little help from my friends

def slet name, &block
  let!(name) { instance_eval(&block) }
  subject { self.send(name) }
end

def fixture *parts
  Pathname.new(__FILE__).dirname.join('fixtures').join(*parts)
end 
