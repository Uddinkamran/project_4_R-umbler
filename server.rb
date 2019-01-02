require 'sinatra'
require "sinatra/reloader"

# Run this script with `bundle exec ruby app.rb`
require 'active_record'

#require model classes
# require './models/cake.rb'

require './models/user.rb'
require './models/post.rb'

# Use `binding.pry` anywhere in this script for easy debugging
require 'pry'
require 'csv'


# Connect to a sqlite3 database
# If you feel like you need to reset it, simply delete the file sqlite makes
if ENV['DATABASE_URL']
  require 'pg'
  # for heroku
  ActiveRecord::Base.establish_connection(ENV['DATABASE_URL'])
else
  require 'sqlite3'

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: 'db/development.db'
)

end

register Sinatra::Reloader
enable :sessions

get '/' do
  erb :login
end

get '/login' do

  erb :login
end


post '/users/login' do
  user = User.find_by(email: params["email"], password: params["password"])
  if user
  @user_all=User.all
   @current_user = user
    session[:user_id] = user.id
    @posts = Post.all
    erb :homepage
  else
    erb :signup
  end
end


get '/signup' do
  erb :signup
end

post '/users/signup' do
  temp_user = User.find_by(email: params["email"])
  if temp_user
    redirect '/login'
  else
    user = User.create(email: params["email"], password: params["password"], firstName: params["first_name"], lastName: params["last_name"], phoneNum: params["phone_number"], gender: params["gender"], pic: params["pic"] )
    session[:user_id] = user.id
    redirect '/login'
  end
end

get '/logout' do
  session[:user_id] = nil
  redirect '/login'
end

get '/feed/delete/:id' do
  Post.find(params["id"]).destroy
  redirect '/feed'
end

get '/logout/delete/:id' do
    user_id = params[:id]
    user = User.find_by_id(user_id)
    user.posts.destroy_all
    User.find(session[:user_id]).destroy
    redirect '/signup'
end

get '/feed' do
  @user_all=User.all
  @current_user = User.find(session[:user_id])
  @posts = Post.all
  erb :homepage
end

post '/feed' do
  @posts = Post.create(text: params["content"], user_id: session[:user_id])
  redirect '/feed'
end

get '/homepage' do
    @user_all=User.all
    @current_user = User.find(session[:user_id])
    @posts = Post.all
    erb :homepage
end

get '/profile' do
    @current_user = User.find(session[:user_id])
    erb :profile
end



