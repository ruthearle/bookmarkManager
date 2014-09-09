require 'sinatra/base'
require 'data_mapper'

env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, "postgres://localhost/bookmark_manager_#{env}")

require './lib/link'
require './lib/tag'

DataMapper.finalize
DataMapper.auto_upgrade!

class BookmarkManager < Sinatra::Base

  get '/' do
	  @links = Link.all
    erb :index
  end

  post '/links' do
    # raise params.inspect
    url         = params["url"]
    title       = params["title"]
    description = params["description"]
    tags        = params["tags"].split(', ').map { |name| Tag.first_or_create(text: name) } #this way creates the child first 'tag' and then creates the parent 'link'

    # ['education, ruby']

    Link.create(:url => url, :title => title, :description => description, tags: tags)
    redirect to ('/')
  end

  get '/tags/:text' do
    tag = Tag.first(:text => params[:text])
    @links = tag ? tag.links : []
    erb :index
  end
  # start the server if ruby file executed directly
end
