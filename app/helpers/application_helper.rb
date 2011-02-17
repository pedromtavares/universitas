module ApplicationHelper
  def render_update_content(update)
    target = update.reference
    case target.class.to_s
    when "User"
	    "#{t('dashboard.updated_status')} \"#{update.user.status}\"" if target == update.user
    when "Course"
    	"#{t('dashboard.created_course')} #{link_to(target, target)}".html_safe
		when "Student"
    	"#{t('dashboard.entered_course')} #{link_to(target.course, target.course)}".html_safe
    end
  end
end
