require 'sinatra'
require 'httparty'

post '/search/' do
  # require 'pry'; binding.pry
  JSONP HTTParty.get("#{POST_API}/#{params[:id]}").body
end
