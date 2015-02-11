require 'google-search'
require 'httparty'

class Search
  KINJA_POST_API = "https://kinja-api.herokuapp.com/post"
  SITES = %w(
    gawker
    jezebel
    lifehacker
    gizmodo
    io9
    kotaku
    jalopnik
    deadspin
  )

  def self.new(query)
    sites = "site:(#{SITES.join(' OR ')}"
    link = Google::Search::Web.new(query: "#{sites} #{query}").first.uri
    get_post_json get_post_id(link)
  end

  def self.get_post_json(id)
    JSON.parse HTTParty.get "#{KINJA_POST_API}/#{id}"
  end

  def self.get_post_id(link)
    if link.match(/\/(\d+)\//)
      link.match(/\/(\d+)\//)[1]
    elsif link.match(/-(\d+)[\/\b\+#]/)
      link.match(/-(\d+)[\/\b\+#]/)[1]
    end
  end

  def self.construct_query(query)
    sites = []
    words = []
    query.split(" ").each do |word|
      if SITES.include? word
        sites.push "#{word}.com"
      else
        words.push word
      end
    end
    sites = SITES.map { |site| "#{site}.com" } if sites.empty?
    "site:(#{sites.join(" OR ")}) #{words.join(" ")}"
  end
end
