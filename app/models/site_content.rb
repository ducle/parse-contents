class SiteContent < ApplicationRecord
  belongs_to :site

  validates :site_id, presence: true
  validates :tag_name, presence: true
  validates :content, presence: true
  
end
