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
    # response = build_response result
    headline = result["headline"]
    url = result["permalink"]
    notifier.channel  = params["channel_id"]
    notifier.username = 'SrchBot'
    notifier.ping "<#{url}|#{headline}>",
      icon_emoji: ":telescope:",
      unfurl_link: true
    status 200
  end
end

def build_response(result)
  headline = result["headline"]
  url = result["permalink"]
  {
    fallback: "#{headline} #{url}",
  }
end
