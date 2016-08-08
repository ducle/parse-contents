require 'rails_helper'

RSpec.describe "SiteContents", type: :request do
  describe "GET /site_contents" do
    it "works! (now write some real specs)" do
      get api_site_contents_path
      expect(response).to have_http_status(200)
    end
  end
end
