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

	def file_size_from_bytes(size)
		in_kb = (size.to_f / 1024)
		in_kb = 1 if in_kb < 1.0
		if in_kb > 1024
			"#{number_with_precision((in_kb / 1024), :precision => 2)} MB"
		else
			"#{in_kb.round} KB"
		end
	end
end
