class ContentController < ApplicationController
  before_action :find_group_by_slug, only: [:new, :edit, :index, :show, :send_gift, :upload, :import, :export, :publish, :save_publish]
  before_action :find_content_by_token, only: [:edit, :show, :update, :send_gift, :upload, :import, :export, :publish, :save_publish]
  before_action :authorize_giver, only: [:edit, :send_gift, :upload, :import]
  before_action :authorize_receiver, only: [:show, :publish, :save_publish]
  skip_before_action :authenticate_user!, only: :index

  def new
    if @group.matched? || (@group.gifted? && (current_user.receiver_match.content.nil? || !current_user.receiver_match.content.given?))
      @content = Content.find_or_create_by(group_id: @group.id, match_id: current_user.receiver_match.id)
      redirect_to edit_group_content_path(@group, @content)
    else
      redirect_to root_path, message: "There doesn't seem to be a reason for you to create content. Am I wrong?"
    end
  end

  def index
    @content = Content.where(group: @group).published
  end

  def show
    redirect_to @group, notice: "Your gift is not ready yet. Check back later." unless @content.given?
  end

  def edit
    render 'show' if @content.given?
  end

  def update
    @content.update_attributes(content_params)
    respond_to do |format|
      if @content.save
        format.html { 
          flash[:success] = "You saved your content. Well, I saved it for you. All you did was click the button."
          redirect_to edit_group_content_path(@group, @content) 
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
    @receiver = current_user.receiver
    if @group && @receiver && @content && @content.body
      UserMailer.send_gift(@receiver, @content, @group).deliver
      @content.given!
      flash[:success] = "You're gift has been sent! Welcome back to the list of good children."
      redirect_to @group
    else
      puts "Starting..."
      puts @group
      puts @receiver
      puts @content
      flash[:error] = "That didn't work out. If your gift is ready and you're still seeing this message then get in touch with Santa."
      redirect_to edit_group_content_path(@group, @content)
    end
  end

  def import
    @content.import_file_contents(content_params[:body])
    if @content.errors.empty? && @content.save
      redirect_to edit_group_content_path(@group, @content)
    else
      flash_errors(@content)
      redirect_to edit_group_content_path(@group, @content)
    end
  end

  def upload
  end

  def export
    export_data = ExportPresenter.new(@content).render_content_for_export(params[:ext])
    if @content.errors.empty?
      send_data export_data[:output], filename: export_data[:filename], type: export_data[:type]
    else
      flash_errors(@content)
      redirect_to edit_group_content_path(@group, @content)
    end
  end

  def publish
  end

  def save_publish
    @first_publish = @content.url.nil?
    respond_to do |format|
      if @content.update(publish_params)
        UserMailer.published_gift(current_user.giver, current_user, @group).deliver if @first_publish
        format.html { 
          flash[:success] = "Your gift has been published for the world to see."
          redirect_to @group 
        }
        format.js
      else
        format.html do
          flash_errors(@content)
          render 'publish'
        end
        format.js
      end
    end
  end

  private

    def content_params
      params.require(:content).permit(:body, :title)
    end

    def publish_params
      params.require(:content).permit(:url)
    end

    def find_content_by_token
      @content = Content.find_by(token: params[:id])
    end

    def find_group_by_slug
      @group = Group.find_by(slug: params[:group_id])
    end

    def authorize_giver
      authorize_content(:giver)
    end

    def authorize_receiver
      authorize_content(:receiver)
    end

    def authorize_content(match_type)
      deny_access unless @content.match.send(match_type) == current_user
    end
end
