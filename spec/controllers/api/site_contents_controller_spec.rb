require 'rails_helper'

RSpec.describe Api::SiteContentsController, type: :controller do

  before(:each) do
    File.open('/tmp/response_body.html', 'w') { |f|
      f.puts '<p>tag p #1</p>'
      f.puts '<h1>tag h1 #1</h1>'
      f.puts '<h1>tag h1 #2</h1>'
      f.puts '<h2>tag h1 #1</h2>'
      f.puts '<h2>tag h1 #2</h2>'
      f.puts '<a href="http://me.now">tag a valid</a>'
      f.puts '<a href="">tag a invalid</a>'
    }
    stub_request(:any, "http://www.example.com").to_return(body: File.new('/tmp/response_body.html'), status: 200)
  end

  context "GET index" do
    before(:each) do
      Site.create(url: "http://www.example.com")
    end

    it "should response status 200" do
      get :index, {page: 1}, { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
      expect(response).to have_http_status(200)
    end

    it "should response json format" do
      get :index, {page: 1}
      expect(response.content_type).to eq('application/json')
    end

    it "should response site and site contents" do
      get :index, {page: 1}
      json = JSON.parse(response.body)
      first_site = json['data'].first['attributes']
      expect(first_site['url']).to eq "http://www.example.com"
      expect(json['data'].length).to eq 5
    end

  end # end index

end
