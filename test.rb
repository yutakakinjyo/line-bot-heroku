ENV['RACK_ENV'] = 'test'

require './app'
require 'test/unit'
require 'rack/test'
require 'webmock/test_unit'

class LineTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_fail_echo
    post '/callback'
    assert_equal last_response.status, 400
  end

  def test_it_echo

    uri_template = Addressable::Template.new Line::Bot::API::DEFAULT_ENDPOINT + '/message/reply'
    stub_request(:post, uri_template)
    
    ENV["LINE_CHANNEL_SECRET"] = "secret"

    body = JSON.generate(
           {
             "events": [
               {
                 "type": "message",
                 "message": {
                   "type": "text",
                   "text": "Hello"
                 }
               }
             ]
           }
         )
    
    hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, ENV["LINE_CHANNEL_SECRET"], body)
    signature = Base64.strict_encode64(hash)
    
    post '/callback', body, {"HTTP_X_LINE_SIGNATURE" => signature}
    assert last_response.ok?
    assert_equal last_response.body, "OK"
  end
  
end
