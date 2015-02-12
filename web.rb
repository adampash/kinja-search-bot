require 'sinatra'
require 'json'
require 'slack-notifier'
require_relative './lib/search'

# SECRETS = YAML::load(IO.read('config/secrets.yml'))
# SEARCH_API = SECRETS["kinja"]["url"]

post '/search' do
  result = Search.new params["text"]
  {text: result["data"]["headline"]}.to_json
  result["data"]["headline"]
end
