class PoolsController < ApplicationController
  before_action :set_pool


  def new
  end

  def show
    if @pool.open?
      @users = User.available.order(created_at: :desc)
    elsif @pool.matched?
      @users = User.playing.order(created_at: :desc)
    end
  end

  def create
  end

  def edit
  end

  def update
  end

  def enquiry
    PoolMailer.enquiry(params[:group], params[:email]).deliver
  end

  private

    def set_pool
      @pool = current_tenant
    end
end