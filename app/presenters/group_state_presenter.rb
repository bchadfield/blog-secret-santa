class GroupStatePresenter < SimpleDelegator
  def initialize(group, user, view)
    super(view)
    @group = group
    @user = user
  end

  def render_intro
  	content_tag(:div, state_intro, class: "csw-group-intro")
  end

  private

    def state_intro
      case @group.status
      when "matched"
        render "groups/matched", group: @group, match: @user.receiver
      when "closed"
        nil
      end
    end
end