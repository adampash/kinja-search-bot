require_relative '../../lib/search'


describe Search do
  let(:search)     { Search.new('test') }

  it "gets the id of a post" do
    post_id = search.get_post_id("http://gawker.com/5897159/unbelievably-wasted-girl-tries-to-have-sex-with-tree-after-getting-in-fight-with-it")
    expect(post_id).to eq "5897159"

    post_id = search.get_post_id("http://newsfeed.gawker.com/a-roof-without-snow-means-reefer-will-grow-1685170905/+tcberman")
    expect(post_id).to eq "1685170905"

    post_id = search.get_post_id("http://newsfeed.gawker.com/a-roof-100-without-snow-means-reefer-will-grow-1685170905/+tcberman")
    expect(post_id).to eq "1685170905"

    post_id = search.get_post_id("http://lifehacker.com/the-always-up-to-date-guide-to-building-a-hackintosh-o-5841604")
    expect(post_id).to eq "5841604"
  end

  it "gets the sites to search" do
    sites = search.construct_query("gawker best thing")
    expect(sites).to eq "site:(gawker.com) best thing"

    sites = search.construct_query("Gawker best thing")
    expect(sites).to eq "site:(gawker.com) best thing"

    sites = search.construct_query("gawker lifehacker best thing")
    expect(sites).to eq "site:(gawker.com OR lifehacker.com) best thing"

    sites = search.construct_query("best thing")
    expect(sites).to eq "site:(gawker.com OR jezebel.com OR lifehacker.com OR gizmodo.com OR io9.com OR kotaku.com OR jalopnik.com OR deadspin.com) best thing"
  end

  it "tests whether or not a link is a post" do
    link = "http://jezebel.com/tag/dogs"
    expect(search.is_post?(link)).to be false

    link = "http://lifehacker.com/the-always-up-to-date-guide-to-building-a-hackintosh-o-5841604"
    expect(search.is_post?(link)).to be true
  end

end
