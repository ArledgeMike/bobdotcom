require 'sinatra'
require 'sinatra/activerecord'
require 'bcrypt'
require './environments'

class Post < ActiveRecord::Base
end
class User < ActiveRecord::Base
end

enable :sessions


helpers do
  
  def login?
    if session[:username].nil?
      # headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
       halt 401, "Not authorized\n"
    else
       return true
    end
  end

  def username
    return session[:username]
  end

end

get "/" do
 # if login?
  login?
  @post = Post.all
  erb :index
 # else
  #  redirect "/login"
#  end
end

get "/login" do
  erb :login
end

post "/login" do
  @user = User.find_by(username: params[:user])
  if @user and @user.password_hash == BCrypt::Engine.hash_secret(params[:pass], @user.password_salt)
    session[:username] = @user.username
    redirect "/main"
  end
end

get "/main" do 
  login?
  @post = Post.all
  erb :main
end

get "/sign-up" do
  erb :signup
end

post "/sign-up" do
  password_salt = BCrypt::Engine.generate_salt
  password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)
  User.create(:first_name => params[:first_name], :last_name => params[:last_name], :username => params[:username], :password_salt => password_salt, :password_hash => password_hash)
  redirect "/login"
end

post "/upload" do
  @post = Post.create(:title => params[:title], :body => params[:body][:filename])
  file = params[:body]
  File.open("public/uploads/" + params[:body][:filename], "wb") do |f|
    f.write(params[:body][:tempfile].read)
    redirect "/main"
  end 
end

get "/uploads/:name" do 
  @image = params[:name]
  erb :images
end

get "/delete/:id" do
  Post.find(params[:id]).delete
  redirect "/main"
end

get "/logout" do
  session[:username] = nil
  redirect "/login"
end

