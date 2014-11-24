env = ENV["RACK_ENV"] || "development"
DataMapper.setup(:default, ENV["DATABASE_URL"])
DataMapper.finalize

DataMapper.auto_upgrade!

