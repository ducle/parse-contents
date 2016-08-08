require 'rails_helper'

RSpec.describe Site, :type => :model do

  context "db" do
    context "indexes" do
      it { should have_db_index(:url).unique(true) }
    end

    context "columns" do
      it { should have_db_column(:url).of_type(:string).with_options(null: false) }
    end
  end

  context "validation" do
    let(:site) { Site.new(url: "url") }

    it "requires url" do
      expect(site).to validate_presence_of(:url)
    end

    it "requires unique url" do
      expect(site).to validate_uniqueness_of(:url)
    end
  end

  context 'associations' do
    it { should have_many(:site_contents).dependent(:destroy) }
  end

  context "class method" do

    context ".parse_content_from_url" do
      context 'invalid endpoint' do
        it "should return json {error: message, success: false}" do
          result = Site.parse_content_from_url("invalid")
          expect(result[:success]).to eq(false)
          expect(result[:error] !~ /Real HTTP connections are disabled/).to eq(false)
        end

      end

      context "valid endpoint" do
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
        it "should return json {content: content, success: true}" do
          result = Site.parse_content_from_url("http://www.example.com")
          expect(result[:success]).to eq(true)
          expect(result[:content]).to be_an Array
        end

        it "should return array of tags" do
          result = Site.parse_content_from_url("http://www.example.com")
          expect(result[:content]).to be_an Array
          expect(result[:content].length).to  eq 5
        end

        it "should return exact content" do
          result = Site.parse_content_from_url("http://www.example.com")
          expect(result[:content]).to  eq(
            [{:tag_name=>"h1", :content=>"tag h1 #1"}, {:tag_name=>"h1", :content=>"tag h1 #2"}, {:tag_name=>"h2", :content=>"tag h1 #1"}, {:tag_name=>"h2", :content=>"tag h1 #2"}, {:tag_name=>"a", :content=>"http://me.now"}]
          )
        end

      end




    end # end parse_content_from_url

    context ".crawl" do
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
      it "get data from URI" do
        page = Site.send(:crawl, "http://www.example.com")
        expect(page.content).to eq File.new('/tmp/response_body.html').read
      end
    end

  end


  context "callback methods" do
    before(:each) do
      File.open('/tmp/response_body.html', 'w') { |f|
        f.puts '<p>tag p #1</p>'
        f.puts '<h1>tag h1 #1</h1>'
        f.puts '<h1>tag h1 #2</h1>'
        f.puts '<h2>tag h2 #1</h2>'
        f.puts '<h2>tag h2 #2</h2>'
        f.puts '<h3>tag h3 #1</h3>'
        f.puts '<a href="http://me.now">tag a valid</a>'
        f.puts '<a href="">tag a invalid</a>'
      }
      stub_request(:any, "http://www.example.com").to_return(body: File.new('/tmp/response_body.html'), status: 200)
    end
    it "should auto_parse_content" do
      site = Site.new(url: 'http://www.example.com')
      expect(site).to receive(:auto_parse_content)
      site.save
    end

    it 'should store all data content' do
      site = Site.new(url: 'http://www.example.com')
      site.save
      expect(site.site_contents.length).to eq(6)
    end

    it 'should store exact tag content' do
      site = Site.new(url: 'http://www.example.com')
      site.save
      expect(site.site_contents.where({tag_name: 'h1'}).count).to eq(2)
      expect(site.site_contents.where({tag_name: 'h2'}).count).to eq(2)
      expect(site.site_contents.where({tag_name: 'h3'}).count).to eq(1)
      expect(site.site_contents.where({tag_name: 'a'}).count).to eq(1)
    end
  end

end
