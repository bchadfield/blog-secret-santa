class ContentController < ApplicationController
  before_action :find_group_by_slug, only: [:new, :edit, :index, :send_gift, :upload, :import, :export]
  before_action :find_content_by_token, :authorize_giver, only: [:edit, :update, :send_gift, :upload, :import, :export]
  before_action :authorize_giver, only: [:edit, :send_gift, :upload, :import]
  before_action :authorize_receiver, only: :show
  skip_before_action :authenticate_user!, only: :index

  def new
    if @group.matched? || (@group.given? && current_user.receiver_match.content.exists?)
      @content = Content.find_or_create_by(group_id: @group.id, match_id: current_user.receiver_match.id)
      redirect_to edit_group_content_path(@group, @content)
    else
      redirect_to root_path, message: "There doesn't seem to be a reason for you to create content. Am I wrong?"
    end
  end

  def index
    unless @group && @group.status == "closed"
      flash[:info] = "This isn't ready yet."
      redirect_to root_path
    end
    @total_count = Match.where(group_id: @group.id).count
    @published_count = Content.published.where(group_id: @group.id).count
    unless @group.gift_time < (Time.now - 30.days) || @total_count == @published_count
      @show_count = true 
      @content = Content.find_by(user_id: current_user.id) if current_user
    end
    @content_items = Content.published.where(group_id: @group.id)
  end

  def edit
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
    if @group && @receiver && @content && @content.body
      @content.update(user_id: @receiver.id, status: "given")
      UserMailer.send_gift(@receiver, @content, @group).deliver
      flash[:sucess] = "You're gift has been sent! Welcome back to the list of good children."
      redirect_to root_path
    else
      puts "Starting..."
      puts @group
      puts @receiver
      puts @content
      flash[:error] = "That didn't work out. If your gift is ready and you're still seeing this message then get in touch with Santa."
      redirect_to edit_content_path(@content)
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

  private

    def content_params
      params.require(:content).permit(:body, :title, :url)
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
