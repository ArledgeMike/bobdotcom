require 'net/http'
require 'uri'

class Slack_Bot

def initialize(username, image_title)
  @user = username
  @title = image_title
  params =  { :token => "xoxp-2538560016-2543438978-2768701902-c864db", :username => "011001100111010101100011011010110110001001100101011000010110111001110011", :channel => "C02NTNN8E", :text => "#{@user} has added an ideation titled: #{@title} to www.bobdotbiz.com"  }

  url = URI("https://slack.com/api/chat.postMessage");
  url.query = URI.encode_www_form(params);
  res = Net::HTTP.get(url)

  end

end
