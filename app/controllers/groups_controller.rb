class GroupsController < ApplicationController
  prepend_before_action :set_group
  
  def show
    if @group.open?
      @users = User.available.order(created_at: :desc)
    elsif @group.matched?
      @users = User.playing.order(created_at: :desc)
    end
  end

  def enquiry
    GroupMailer.enquiry(params[:group], params[:email]).deliver
  end

  private

    def set_group
      @current_tenant = @group = Group.find_by(slug: params[:id])
    end
end