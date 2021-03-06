require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'sinatra/redirect_with_flash'
require 'net/sftp'
require './environments'
require 'will_paginate'
require 'will_paginate/active_record'
require './slack_bot'

class Post < ActiveRecord::Base
  validates :title, presence: true
  validates :body, presence: true
end

class User < ActiveRecord::Base
end

enable :sessions

helpers do
  
  def login?
    if !session[:access_token]
      halt 401, "Not authorized\n"
    end
  end

  def link_out(post)
    if post.post_link.empty?
      "#{SITE_URL + post.body}"
    else
      "#{post.post_link}"	   
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
#@post = Post.limit(15).order("created_at DESC")
 @post = Post.paginate(:page => params[:page], :per_page => 20).order("created_at DESC")
  @page_id = "main"
  @page_class ="home"
  erb :index, :layout => :main_page
end

get "/login" do
  redirect "https://slack.com/oauth/authorize?client_id=2538560016.2783440703&redirect_uri=http://www.bobdotbiz.com/auth"      
end

get "/auth" do 
  session_code = request.env['rack.request.query_hash']['code']
  slack_bot = Slack_Bot.new
  token = slack_bot.make_hand_shake session_code
  session[:access_token] = token['access_token']
  redirect "/main"
end

get "/main" do
  login?
  @page_id = "admin"
  @page_class ="main"
  @post = Post.order "created_at DESC"
  erb :main
end

post "/upload" do
  post = Post.new	
  params[:body] ||= "" 
  params[:post_link] ||= "#{SITE_URL}" 
  post.title = params[:title]
  post.post_link = params[:post_link]
  post.body = params[:body][:filename]
  
  if post.valid?
    file ="#{params[:body][:tempfile].path}"
    connect = Net::SSH.start("churchofbitcoin.org", "mike", :password => "mike123")
    connect.sftp.upload!(file, "/srv/www/codeandpen/codeandpen.com/public_html/uploads/#{params[:body][:filename]}")
    post.save
    slack_bot = Slack_Bot.new("#{SITE_URL}")
    slack_bot.upload_msg("#{post.title}")
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

get "/logout" do
  session[:access_token] = nil
  redirect "/"
end


