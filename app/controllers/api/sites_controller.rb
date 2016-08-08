class Api::SitesController < Api::ApiController

  def create
    @site = Site.new(url: params[:url])
    if @site.save
      render json: {success: true, contents: @site.site_contents}, status: 200
    else
      render json: {success: false, message: @site.errors.full_messages.join(', ')}, status: 400
    end
  end

end
