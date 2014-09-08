require 'sinatra/base'
env = ENV["RACK_ENV"] || "development"
DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")
require './lib/link'
Datamapper.finalize
Datamapper.auto_upgrade!

class BookmarkManager < Sinatra::Base

 get '/' do
    'Hello BookmarkManager!'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
