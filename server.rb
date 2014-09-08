require 'sinatra/base'
require 'data_mapper'

env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

require './lib/link'
DataMapper.finalize
DataMapper.auto_upgrade!

class BookmarkManager < Sinatra::Base

get '/' do
  erb :index.rb
end

  # start the server if ruby file executed directly
end
