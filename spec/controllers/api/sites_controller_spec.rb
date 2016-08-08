require 'rails_helper'

RSpec.describe Api::SitesController, :type => :controller do
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

  context 'POST /create' do
    it "should response 400 status for invalid endpoint" do
      post :create, {url: 'invalid-endpoint'}
      expect(response).to have_http_status(400)
    end

    it "should response json with success and message keys for failed case" do
      post :create, {url: 'invalid'}
      json = JSON.parse(response.body)
      expect(json).to have_key('success')
      expect(json).to have_key('message')
      expect(json['success']).to eq(false)
    end

    it "should response 200 status for valid endpoint" do
      post :create, {url: 'http://www.example.com'}
      expect(response).to have_http_status(200)
    end

    it "should response json" do
      post :create, {url: 'http://www.example.com'}
      expect(response.content_type).to eq('application/json')
    end

    it "should response json with success and contents keys for successful case" do
      post :create, {url: 'http://www.example.com'}
      json = JSON.parse(response.body)
      expect(json).to have_key('success')
      expect(json).to have_key('contents')
      expect(json['contents'].length).to eq(5)
      expect(json['success']).to eq(true)
    end


  end # end create

end
