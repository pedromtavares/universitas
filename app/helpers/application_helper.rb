module ApplicationHelper
  def render_update_content(update)
    target = update.reference
    case target.class.to_s
      when "User"
        if target == update.user
          "updated status to \"#{update.user.status}\""
        end
      when "Course"
        if update.user.teacher_of?(target)
          "created a course called #{link_to(target, target)}".html_safe
        else
          "entered a course called #{link_to(target, target)}".html_safe
        end
    end
  end
end
