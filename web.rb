require 'sinatra'
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
    search = Search.new(params["text"]).run
    result = search.result
    notifier.ping "First result for *#{search.query}* on #{search.domains}",
      icon_emoji: ":telescope:",
      attachments: [build_attachment(result)],
      channel: params["channel_id"],
      username: "SrchBot"
    status 200
  end
end

AVATAR_URL = "http://i.kinja-img.com/gawker-media/image/upload/s--jqe8lYjQ--/c_fill,fl_progressive,g_center,h_80,q_80,w_80"
def build_attachment(result)
  headline = result["headline"]
  url = result["permalink"]
  author_name = result["author"]["displayName"]
  author_icon = "#{AVATAR_URL}/#{result["author"]["avatar"]["id"]}.#{result["author"]["avatar"]["format"]}"
  img = result["parsedBody"]["sharingMainImage"]["src"]
  {
    fallback: "<#{url}|#{headline}>",
    author_name: author_name,
    author_icon: author_icon,
    title: headline,
    title_link: url,
    text: result["parsedBody"]["compact"],
    image_url: img
  }
end
