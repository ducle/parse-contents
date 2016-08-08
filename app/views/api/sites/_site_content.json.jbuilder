json.extract! site_content, :id, :content, :tag_name, :site_id, :created_at, :updated_at
json.url{ site_content.site.url }
json.url site_content_url(site_content, format: :json)
