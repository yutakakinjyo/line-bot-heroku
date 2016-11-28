ENV['RACK_ENV'] = 'test'

require './app'
require 'test/unit'
require 'rack/test'

class LineTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_fail_echo
    # post '/callback', :name => "hoge"
    # assert_equal last_response.status, 400
  end

  def test_it_echo

    ENV["LINE_CHANNEL_SECRET"] = "secret"
    ENV["LINE_CHANNEL_TOKEN"] = "token"
    body = JSON.generate(
           {
             "events": [
                         {
                           "replyToken": "replayToken",
                          "type": "message",
                          "message": {
                                       "type": "text",
                                       "text": "hoge"
                                     }
                         }
                       ]
           }
         )

    hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, ENV["LINE_CHANNEL_SECRET"], body)
    signature = Base64.strict_encode64(hash)
    
    post '/callback', body, {"HTTP_X_LINE_SIGNATURE" => signature}
    assert last_response.ok?
  end
  
end
