
require 'dm-core'
require 'dm-aggregates'
require 'dm-constraints'
require 'dm-migrations'
require 'dm-transactions'
require 'dm-serializer'
require 'dm-timestamps'
require 'dm-validations'

require 'logger'

db_url = ENV['DATABASE_URL'] or fail "Please specify DATABASE_URL in environment."

DataMapper.logger = DataMapper::Logger.new($stderr, :debug)
DataMapper.setup(:default, db_url)

