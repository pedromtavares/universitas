module ApplicationHelper
  def render_update_content(update)
    target = update.reference
    case target.class.to_s
      when "User"
        if target == update.user
          "#{t('dashboard.updated_status')} \"#{update.user.status}\""
        end
      when "Course"
        if update.user.teacher_of?(target)
          "#{t('dashboard.created_course')} #{link_to(target, target)}".html_safe
        else
          "#{t('dashboard.entered_course')} #{link_to(target, target)}".html_safe
        end
    end
  end
end
