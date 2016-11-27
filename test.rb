ENV['RACK_ENV'] = 'test'

require './app'
require 'test/unit'
require 'rack/test'

class LineTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_echo
    get '/callbacka'
    assert last_response.ok?
  end

end
