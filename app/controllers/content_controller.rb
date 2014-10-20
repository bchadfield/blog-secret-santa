class ContentController < ApplicationController
  before_action :find_draw, only: [:index, :send_gift]
  before_action :find_content, :authorize, only: [:edit, :update, :send_gift]
  skip_before_action :authenticate_user!, only: :index

  def new
    @pool = Pool.first
    if @pool.matched?
      @content = Content.find_or_create_by(draw_id: @pool.id, user_id: current_user.id)
    elsif @pool.closed? && !Content.joins("INNER JOIN users ON users.id = content.user_id INNER JOIN matches ON users.id = matches.receiver_id")
                                    .where("content.status = 'given' AND matches.giver_id = ?", current_user.id).first
      @content = Content.find_or_create_by(draw_id: @pool.id, user_id: current_user.id, status: nil)
    end
    if @content
      redirect_to edit_content_path(@content)
    else
      redirect_to root_path, message: "There doesn't seem to be a reason for you to create content. Am I wrong?"
    end
  end

  def index
    unless @pool && @pool.status == "closed"
      flash[:info] = "This isn't ready yet."
      redirect_to root_path
    end
    @total_count = Match.where(draw_id: @pool.id).count
    @published_count = Content.published.where(draw_id: @pool.id).count
    unless @pool.gift_time < (Time.now - 30.days) || @total_count == @published_count
      @show_count = true 
      @content = Content.find_by(user_id: current_user.id) if current_user
    end
    @content_items = Content.published.where(draw_id: @pool.id)
  end

  def show
    @content = Content.find(params[:id])
  end

  def edit
    @pool = Pool.first
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

  def send_gift
    @receiver = User.joins("INNER JOIN matches ON matches.receiver_id = users.id").where("matches.giver_id = ?", current_user.id).first
    if @pool && @receiver && @content && @content.body
      @content.update(user_id: @receiver.id, status: "given")
      UserMailer.send_gift(@receiver, @content, @pool).deliver
      flash[:sucess] = "You're gift has been sent! Welcome back to the list of good children."
      redirect_to root_path
    else
      puts "Starting..."
      puts @pool
      puts @receiver
      puts @content
      flash[:error] = "That didn't work out. If your gift is ready and you're still seeing this message then get in touch with Santa."
      redirect_to edit_content_path(@content)
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
