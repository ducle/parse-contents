class Api::SiteContentsController < Api::ApiController
  def index
    @site_contents = SiteContent.order("created_at DESC").page(params[:page]).per(30)
    render json: @site_contents
  end
end
