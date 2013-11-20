class DrawsController < ApplicationController
  skip_before_action :authenticate, only: :show

  def new
  end

  def show
    @draw = Draw.first
    @users = User.available.order(created_at: :desc).limit(10)
    @total_users = User.available.count
    @match = Match.find_by(draw_id: @draw.id, giver_id: current_user.id) if current_user
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
