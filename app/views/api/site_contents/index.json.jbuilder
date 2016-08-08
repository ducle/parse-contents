json.array! @site_contents, partial: 'site_contents/site_content', as: :site_content
json.total_pages @site_contents.total_pages
json.total_pages @site_contents.total_pages
json.total_entries @site_contents.total_count
json.per_page 30
