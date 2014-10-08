require 'net/http'
require 'uri'

class Slack_Bot

def initialize(username, image_title)
  @user = username
  @title = image_title
  params =  { :token => "xoxp-2538560016-2543438978-2768701902-c864db", :username => "TESTBOT-NINER", :channel => "C02NRLGSF", :text => "#{@user} added the file #{@title} to www.bobdotbiz.com"  }

  url = URI("https://slack.com/api/chat.postMessage");

  url.query = URI.encode_www_form(params);

  res = Net::HTTP.get(url)

  puts res

  end


end
