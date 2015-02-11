require_relative '../../lib/search'

describe Search do
  it "gets the id of a post" do
    post_id = Search.get_post_id("http://gawker.com/5897159/unbelievably-wasted-girl-tries-to-have-sex-with-tree-after-getting-in-fight-with-it")
    expect(post_id).to eq "5897159"

    post_id = Search.get_post_id("http://newsfeed.gawker.com/a-roof-without-snow-means-reefer-will-grow-1685170905/+tcberman")
    expect(post_id).to eq "1685170905"

    post_id = Search.get_post_id("http://newsfeed.gawker.com/a-roof-100-without-snow-means-reefer-will-grow-1685170905/+tcberman")
    expect(post_id).to eq "1685170905"
  end

  it "gets the sites to search" do
    sites = Search.construct_query("gawker best thing")
    expect(sites).to eq "site:(gawker.com) best thing"

    sites = Search.construct_query("gawker lifehacker best thing")
    expect(sites).to eq "site:(gawker.com OR lifehacker.com) best thing"

    sites = Search.construct_query("best thing")
    expect(sites).to eq "site:(gawker.com OR jezebel.com OR lifehacker.com OR gizmodo.com OR io9.com OR kotaku.com OR jalopnik.com OR deadspin.com) best thing"
  end

end
