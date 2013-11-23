class ContentController < ApplicationController
  before_action :find_content, :authorize, only: [:show, :update]
  skip_before_action :authenticate, only: :index
  def new
    @draw = Draw.first
    @content = Content.create_with(title: "Blog for draw #{@draw.draw_time.strftime('%Y')}")
                      .find_or_create_by(draw_id: @draw.id, user_id: current_user.id)
    redirect_to @content
  end

  def index
    @draw = Draw.find(params[:draw_id])
    unless @draw && @draw.status == "closed"
      flash[:info] = "This isn't ready yet."
      redirect_to root_path
    end
    @content_items = Content.where(draw_id: @draw.id)
  end

  def show
    @content = Content.find(params[:id])
  end

  def update
    @content.update_attributes(content_params)
    respond_to do |format|
      if @content.save
        format.html { redirect_to @content }
        format.json { head :no_content }
      else
        format.html { render "show" }
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def content_params
      params.require(:content).permit(:body, :title)
    end

    def find_content
      @content = Content.find(params[:id])
    end

    def authorize
      unless @content.user == current_user
        flash[:error] = "You don't have access."
        redirect_to root_path
      end
    end
end
