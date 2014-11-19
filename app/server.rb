require 'sinatra/base'
require 'data_mapper'
require 'rack-flash'

require './lib/link'
require './lib/tag'
require './lib/user'

require_relative 'data_mapper_setup'
require_relative 'helpers/application'

class BookmarkManager < Sinatra::Base

  include Helpers

  enable :sessions
  set :session_secret, 'super secret'
  use Rack::Flash

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

    Link.create(:url         => url,
                :title       => title,
                :description => description,
                :tags        => tags)
    redirect to ('/')
  end

  get '/tags/:text' do
    tag = Tag.first(:text => params[:text])
    @links = tag ? tag.links : []
    erb :index
  end

  get '/users/new' do
    @user = User.new
    erb :"users/new"
  end

  post '/users' do
    @user = User.create(:email                => params[:email],
                       :password              => params[:password],
                       :password_confirmation => params[:password_confirmation])
    if @user.save
      session[:user_id] = @user.id
      redirect to('/')
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :"users/new"
    end
  end

  get '/sessions/new' do
    erb :"sessions/new"
  end

  post '/sessions' do
    email, password = params[:email], params[:password]
    @user = User.authenticate(email, password)
    if @user
      session[:user_id] = @user.id
      redirect to ('/')
    else
      flash[:errors] = ["The email or password is incorrect"]
      erb :"sessions/new"
    end
  end
 # start the server if ruby file executed directly
end
