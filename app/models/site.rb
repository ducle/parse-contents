class Site < ApplicationRecord

    has_many :site_contents, dependent: :destroy

    before_create :auto_parse_content

    accepts_nested_attributes_for :site_contents

    validates :url, presence: true, uniqueness: true, format: { with: URI::regexp(%w(http https)) }


    class << self

      def parse_content_from_url(url)
        begin
          web_page = crawl(url)
          doc = Nokogiri::HTML(web_page.content)
          content = []
          doc.css('h1, h2, h3, a').each do |tag|
            if tag.name == 'a'
              content << {
                tag_name: tag.name,
                content: tag.attr('href')
              } unless tag.attr('href').blank?
            else
              content << {
                tag_name: tag.name,
                content: tag.text.strip
              }
            end
          end
          return {content: content, success: true}
        rescue Exception => ex
          Rails.logger.error("\n!!!EXCEPTION parsing from #{url}")
          return {error: ex.message, success: false}
        end
      end

      private
      def crawl(url)
        @agent ||= Mechanize.new { |agent|
    		  agent.user_agent_alias = 'Mac Safari'
          agent.keep_alive  = false
          agent.follow_meta_refresh = true
    		}
        @agent.get(url)
      end
    end


    private

    def auto_parse_content
      if url !~ URI::regexp(%w(http https))
        errors.add(:url, "is invalid")
        return false
      end

      result = Site.parse_content_from_url(url)
      unless result[:success]
        errors.add(:url, "is invalid endpoint")
        return false
      end
      self.site_contents_attributes = result[:content]
    end

end
