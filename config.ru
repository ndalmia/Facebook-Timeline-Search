require 'sinatra'

set :run, false # this disables Sinatra trying to start Thin; lets Rack start Thin

require File.dirname(__FILE__) + "/app.rb"

# Rack middleware goes here
use Rack::Deflater

# the following is key. Sinatra Modular apps could be started with just run
# Server, but when deployed to VCAP, you need to map the application #to a
# location. In this instance, I want my server application to be mapped to the
# default path.
map '/' do
  run MyApp
end