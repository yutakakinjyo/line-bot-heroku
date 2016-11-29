require './app'
require 'test/unit'
require 'webmock/test_unit'

class EchoTest < Test::Unit::TestCase
  
  def test_it_echo

    uri_template = Addressable::Template.new Line::Bot::API::DEFAULT_ENDPOINT + '/message/reply'
    stub_request(:post, uri_template).to_return { |request| {:body => request.body, :status => 200} }

    response = echo("hoge", "reply_token")
    assert_equal JSON.parse(response.body)['messages'][0]['text'], "hoge"
    
  end
  
end
