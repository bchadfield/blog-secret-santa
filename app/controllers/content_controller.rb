class ContentController < ApplicationController
  before_action :find_draw, only: :index
  before_action :find_content, :authorize, only: [:edit, :update]
  skip_before_action :authenticate, only: :index

  def new
    @draw = Draw.first
    @content = Content.find_or_create_by(draw_id: @draw.id, user_id: current_user.id)
    redirect_to edit_content_path(@content)
  end

  def index
    unless @draw && @draw.status == "closed"
      flash[:info] = "This isn't ready yet."
      redirect_to root_path
    end
    @total_count = Content.where(draw_id: @draw.id).count
    @published_count = Content.published.where(draw_id: @draw.id).count
    unless @draw.gift_time < (Time.now - 30.days) || @total_count == @published_count
      @show_count = true 
      @content = Content.find_by(user_id: current_user.id)
    end
    @content_items = Content.published.where(draw_id: @draw.id)
  end

  def show
    @content = Content.find(params[:id])
  end

  def edit
    @draw = Draw.first
    @content = Content.find(params[:id])
  end

  def update
    @content.update_attributes(content_params)
    respond_to do |format|
      if @content.save
        format.html { 
          flash[:success] = "You saved your content. Well, I saved it for you. All you did was click the button."
          redirect_to edit_content_path(@content) 
        }
        format.js
        format.json { head :no_content }
      else
        format.html { render "show" }
        format.js
        format.json { render json: @content.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def content_params
      params.require(:content).permit(:body, :title, :url)
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
