require 'sinatra'
require 'json'
require 'slack-notifier'
require_relative './lib/search'

SECRETS = YAML::load(IO.read('config/secrets.yml'))
SLACK_TOKEN = SECRETS["slack"]["token"] || ENV["SLACK_TOKEN"]
SLACK_WEBHOOK = SECRETS["slack"]["webhook"] || ENV["SLACK_WEBHOOK"]
# SEARCH_API = SECRETS["kinja"]["url"]
notifier = Slack::Notifier.new SLACK_WEBHOOK

post '/search' do
  unless params["token"] == SLACK_TOKEN
    status 404
  else
    result = Search.new params["text"]
    {text: result["data"]["headline"]}.to_json
    result["data"]["headline"]
  end
end
