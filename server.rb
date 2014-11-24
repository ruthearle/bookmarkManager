#require 'sinatra/base'
require 'sinatra'
require 'data_mapper'
require 'rack-flash'
require 'sinatra/partial'
require 'mailgun'
require 'rest_client'

require_relative 'models/link'
require_relative 'models/tag'
require_relative 'models/user'
require_relative 'data_mapper_setup'
require_relative 'helpers/application'
require_relative 'helpers/mailgun'

require_relative 'controllers/users'
require_relative 'controllers/sessions'
require_relative 'controllers/links'
require_relative 'controllers/tags'
require_relative 'controllers/application'


#class BookmarkManager < Sinatra::Base
  #register Sinatra::Partial

  include Helpers

  enable :sessions
  set :session_secret, 'super secret'
  use Rack::Flash
  use Rack::MethodOverride
  set :partial_template_engine, :erb
 # start the server if ruby file executed directly
#end
