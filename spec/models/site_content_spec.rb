require 'rails_helper'

RSpec.describe SiteContent, type: :model do
  context "db" do
    context "columns" do
      it { should have_db_column(:site_id).of_type(:integer) }
      it { should have_db_column(:tag_name).of_type(:string) }
      it { should have_db_column(:content).of_type(:string) }
    end

  end

  context "validation" do
    let(:site_content) { SiteContent.new(site_id: 1) }

    it "requires site_id" do
      expect(site_content).to validate_presence_of(:site_id)
    end

    it "requires tag_name" do
      expect(site_content).to validate_presence_of(:tag_name)
    end
  end

  context 'associations' do
    it { should belong_to(:site) }
  end
end
