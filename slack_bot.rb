require 'net/http'
require 'uri'
require 'rack'
require 'json'

class Slack_Bot
  
  def initialize(current_url= "")
    @current_url = current_url
    @base_url = "https://slack.com/api/"
    @slack_params = Rack::Utils.parse_query URI(@current_url).query
  end
  
  def auth_test
    method = "auth.test"
    url = URI("#{@base_url + method}")
    @token_status = make_hand_shake(@slack_params, @current_url)
  end
  
  def upload_msg(image_title="default image title")
    title = image_title
    method = "chat.postMessage"
    params =  { :token => "xoxp-2538560016-2543438978-2768701902-c864db", :username => "011001100111010101100011011010110110001001100101011000010110111001110011", :channel => "C02NTNN8E", :icon_url => "http://codeandpen.com/uploads/slack_bot.png", :text => "An ideation titled: #{title}\n has been added to www.bobdotbiz.com"  }
    url = URI("#{@base_url + method}")
    url.query = URI.encode_www_form(params)
    res = Net::HTTP.get(url)
  end

end

def make_hand_shake(params_in, redirect_uri)
  @params_slack = params_in
  @c_id = "2538560016.2783440703"
  @c_secret = "7882791a1fd65a1d5b5420e4a533fbe8"
  method = "oauth.access"
  params = {:client_id => @c_id, :client_secret => @c_secret, :code => @params_slack['code'], :redirect_url => @current_url}
  url = URI("#{@base_url + method}")
  url.query = URI.encode_www_form(params)
  res = Net::HTTP.get(url)
  JSON.parse(res)
end


