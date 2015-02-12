require 'sinatra'
require 'json'
require 'slack-notifier'
require_relative './lib/search'
require_relative './config/config'

SLACK_TOKEN = SERVICES["slack"]["token"]
SLACK_WEBHOOK = SERVICES["slack"]["webhook"]
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
