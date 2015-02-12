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

  def initialize(query)
    link = ""
    Google::Search::Web.new(query: construct_query(query)).each do |result|
      if is_post?(result.uri)
        link = result.uri
        break
      end
    end
    @result = get_post_json(get_post_id(link))["data"]
  end

  def self.is_post?(link)
    !get_post_id(link).nil?
  end

  def self.get_post_json(id)
    JSON.parse HTTParty.get "#{KINJA_POST_API}/#{id}"
  end

  def self.get_post_id(link)
    if link.match(/\/(\d+)\//)
      link.match(/\/(\d+)\//)[1]
    elsif link.match(/-(\d+)[\/\b\+#]?/)
      link.scan(/-(\d+)[\/\b\+#]?/).last.last
    end
  end

  def self.construct_query(query)
    sites = []
    words = []
    query.split(" ").each do |word|
      lower_word = word.downcase
      if SITES.include? lower_word
        sites.push "#{lower_word}.com"
      else
        words.push word
      end
    end
    sites = SITES.map { |site| "#{site}.com" } if sites.empty?
    @query = words.join(" ")
    "site:(#{sites.join(" OR ")}) #{words.join(" ")}"
  end
end
