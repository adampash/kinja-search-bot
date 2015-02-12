require 'sinatra'
require 'json'
require 'slack-notifier'
require_relative './lib/search'

# SECRETS = YAML::load(IO.read('config/secrets.yml'))
# SEARCH_API = SECRETS["kinja"]["url"]

post '/search' do
  puts params
  puts "FIRST PARAMS!\n\n"
  params = JSON.parse request.body.read
  puts params
  puts "SECOND PARAMS!"

  result = Search.new params["text"]
  result["data"]["headline"]
end
