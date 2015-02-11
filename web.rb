require 'sinatra'
require 'json'
require 'slack-notifier'
require_relative './lib/search'

# SECRETS = YAML::load(IO.read('config/secrets.yml'))
# SEARCH_API = SECRETS["kinja"]["url"]

post '/search' do
  params = JSON.parse request.body.read

  result = Search.new params["text"]
  puts result["data"]["headline"]
end
