class DrawsController < ApplicationController
  skip_before_action :authenticate, only: :show
  before_action :find_draw, only: [:show, :edit, :update]

  def to_param
    gift_time.strftime("%Y")
  end

  def new
  end

  def show
    @users = User.available.order(created_at: :desc).limit(10)
    @total_users = User.available.count
    @match = Match.find_by(draw_id: @draw.id, giver_id: current_user.id) if current_user
    if @draw.closed?
      @not_written_count = Match.count - Content.where("body is not null").count
      if current_user
        @gift = Content.find_by(user_id: current_user, status: "given") 
        
        @content = Content.joins("INNER JOIN users ON users.id = content.user_id INNER JOIN matches ON users.id = matches.receiver_id")
                          .where("content.status = 'given' AND matches.giver_id = ?", current_user.id)
                          .first
      end
    end
  end

  def create
  end

  def edit
  end

  def update
  end
end