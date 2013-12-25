class ContentController < ApplicationController
  before_action :find_draw, only: :index
  before_action :find_content, :authorize, only: [:edit, :update]
  skip_before_action :authenticate, only: :index

  def new
    @draw = Draw.first
    if @draw.matched?
      @content = Content.find_or_create_by(draw_id: @draw.id, user_id: current_user.id)
    elsif @draw.closed? && !Content.joins("INNER JOIN users ON users.id = content.user_id INNER JOIN matches ON users.id = matches.receiver_id")
                                    .where("content.status = 'given' AND matches.giver_id = ?", current_user.id).first
      @content = Content.find_or_create_by(draw_id: @draw.id, user_id: current_user.id, status: nil)
    end
    if @content
      redirect_to edit_content_path(@content)
    else
      redirect_to root_path, message: "There doesn't seem to be a reason for you to create content. Am I wrong?"
    end
  end

  def index
    unless @draw && @draw.status == "closed"
      flash[:info] = "This isn't ready yet."
      redirect_to root_path
    end
    @total_count = Match.where(draw_id: @draw.id).count
    @published_count = Content.published.where(draw_id: @draw.id).count
    unless @draw.gift_time < (Time.now - 30.days) || @total_count == @published_count
      @show_count = true 
      @content = Content.find_by(user_id: current_user.id) if current_user
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
