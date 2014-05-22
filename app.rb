require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'bcrypt'
require 'net/sftp'
require './environments'

class Post < ActiveRecord::Base
  validates :title, presence: true
  validates :body, presence: true
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

  def h(text)
    Rack::Utils.escape_html(text)
  end

  def is_selected(current_type, user_type)
    if current_type == user_type 
      %q{selected}
    end
  end

end

get "/" do
  login?
  @post = Post.order "created_at DESC"
  @page_id = "main"
  @page_class ="home"
  erb :index
end

get "/login" do
  @page_id = "admin"
  @page_class ="login"
  erb :login
end

post "/login" do
  @user = User.find_by(username: params[:user])
  if @user and @user.password_hash == BCrypt::Engine.hash_secret(params[:pass], @user.password_salt)
    session[:username] = @user.username
    session[:user_type] = "default"
    redirect "/main"
  else
    redirect "/login", :flash => {:login_error => 'try again goon.'}      
  end
end

get "/main" do
  login?
  @post = Post.order "created_at DESC"
  @user =  User.all
  @page_id = "admin"
  @page_class ="main"
  erb :main
end

get "/sign-up" do
  @page_id = "admin"
  @page_class ="signup"
  erb :signup
end

post "/sign-up" do
  password_salt = BCrypt::Engine.generate_salt
  password_hash = BCrypt::Engine.hash_secret(params[:password], password_salt)
  User.create(:first_name => params[:first_name], :last_name => params[:last_name], :username => params[:username], :password_salt => password_salt, :password_hash => password_hash)
  redirect "/login"
end

post "/upload" do
  post = Post.new	
  if !params[:body] 
   params[:body] = {} 
  end
  post.title = params[:title]
  post.body = params[:body][:filename]
  if post.valid?
    file ="#{params[:body][:tempfile].path}"
    connect = Net::SSH.start("thelostideas.com", "mike", :password => "mike")
    connect.sftp.upload!(file, "/srv/www/codeandpen/codeandpen.com/public_html/uploads/#{params[:body][:filename]}")
    post.save
    redirect "/main"
  else
    redirect "/main", :flash => post.errors.messages
  end
end

get "/uploads/:name" do 
  @image = params[:name]
  erb :images
end

get "/edit/:id" do
  login?
  @page_id = "admin"
  @page_class = "edit_post"
  @post = Post.find params[:id]
  erb :edit
end

patch "/edit/post" do
  @post = Post.find params[:id]
  @post[:title] = params[:title]
  @post.save
  redirect "/main"
end

get "/delete/:id" do
  Post.find(params[:id]).delete
  redirect "/main"
end

get "/user/edit/:id" do
  login?
  @page_id = "admin"
  @page_class="edit_user"
  @user = User.find params[:id]
  erb :edit_user
end

patch "/edit/user" do
  @user = User.find params[:id] 
  params.each do |x, y|
    if x  != "_method"
      @user[x] = y
    end
  end
  @user.save
  redirect "/main"
end

get "/logout" do
  session[:username] = nil
  session[:user_type] = nil
  redirect "/login"
end
