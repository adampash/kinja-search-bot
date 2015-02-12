require 'sinatra'
require 'json'
require 'slack-notifier'
require_relative './lib/search'

SECRETS = YAML::load(IO.read('config/secrets.yml'))
# SEARCH_API = SECRETS["kinja"]["url"]
notifier = Slack::Notifier.new SECRETS["slack"]["url"]

post '/search' do
  unless params["token"] == SECRETS["slack"]["token"]
    status 404
  else
    result = Search.new params["text"]
    {text: result["data"]["headline"]}.to_json
    result["data"]["headline"]
  end
end
