class Santa::ContentController < ApplicationController
  before_action :find_group_by_slug, only: [:index, :show, :edit, :update]
  before_action :find_content_by_token, only: [:show, :edit, :update]

  def index
    @content = Content.where(group: @group)
  end

  def show
  end

  def edit
  end

  def update
    unless !@content.update(content_params)
      flash_errors(@content)
    end
    redirect_to santa_group_content_path(@group, @content)
  end

  private

    def content_params
      params.require(:content).permit(:title, :url, :status)
    end

    def find_content_by_token
      @content = Content.find_by(token: params[:id])
    end

    def find_group_by_slug
      @group = Group.find_by(slug: params[:group_id])
    end
end
