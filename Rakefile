require 'data_mapper'
require  'dm-migrations'
require './app/data_mapper_setup'

task :auto_upgrade do
  # non-destructive change to DB
  DataMapper.auto_upgrade!
  p "Auto-upgrade complete (no data loss)"
end

task :auto_migrate do
  # force table creation. Destructive!
  DataMapper.auto_migrate!
  p "Auto_migrate complete (data could have been lost)"
end
