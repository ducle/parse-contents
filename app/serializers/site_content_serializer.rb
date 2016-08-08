class SiteContentSerializer < ActiveModel::Serializer
  attributes :id, :content, :tag_name, :site_id, :url
  alias_method :site_content, :object

  def url
    site_content.site.url
  end
end
