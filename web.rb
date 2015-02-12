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
      attachments: [build_attachment(result)]
    status 200
  end
end

AVATAR_URL = "http://i.kinja-img.com/gawker-media/image/upload/s--jqe8lYjQ--/c_fill,fl_progressive,g_center,h_80,q_80,w_80"
def build_attachment(result)
  headline = result["headline"]
  url = result["permalink"]
  author_name = result["author"]["displayName"]
  author_icon = "#{AVATAR_URL}/#{result["author"]["avatar"]["id"]}.#{result["author"]["avatar"]["format"]}"
  {
    fallback: "<#{url}|#{headline}>",
    author_name: author_name,
    author_icon: author_avatar,
    title: headline,
    title_link: url,
    image_url: result["images"][0]["uri"]
  }
end
