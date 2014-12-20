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
      when "gifted"
        gift = current_user.giver_match ? current_user.giver_match.content : nil
        render "groups/gifted", group: @group, gift: gift
      when "closed"
        nil
      end
    end
end