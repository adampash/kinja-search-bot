require 'sinatra'
require 'json'
require 'slack-notifier'

if settings.development?
  require 'dotenv'
  Dotenv.load
end

require_relative './lib/search'

SLACK_TOKEN = ENV["SLACK_TOKEN"]
SLACK_WEBHOOK = ENV["SLACK_WEBHOOK"]

notifier = Slack::Notifier.new SLACK_WEBHOOK

post '/search' do
  unless params["token"] == SLACK_TOKEN
    status 404
  else
    result = Search.new params["text"]
    {text: result["data"]["headline"]}.to_json

    notifier.channel  = "@adampash" #params["channel_name"]
    notifier.username = 'SrchBot'
    notifier.ping result["data"]["headline"]
    status 200
  end
end
