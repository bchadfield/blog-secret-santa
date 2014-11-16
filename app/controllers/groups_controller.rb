class GroupsController < ApplicationController
  before_action :set_group


  def new
  end

  def show
    if @group.open?
      @users = User.available.order(created_at: :desc)
    elsif @group.matched?
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
    GroupMailer.enquiry(params[:group], params[:email]).deliver
  end

  private

    def set_group
      @group = current_tenant
    end
end