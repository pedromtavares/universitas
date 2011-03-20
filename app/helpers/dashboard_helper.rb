module DashboardHelper
	def render_update_content(update)
    target = update.target
    case target.class.to_s
    when "User"
	    "#{t('dashboard.updated_status')} \"#{update.creator.status}\"" if target == update.creator
    when "Group"
    	"#{t('dashboard.created_group')} #{link_to(target, target)}".html_safe
		when "GroupMember"
    	"#{t('dashboard.joined_group')} #{link_to(target.group, target.group)}".html_safe
		when "UserDocument"
			"#{t('dashboard.document_added')} #{target.name}"
    end
  end

	def render_update_creator(update)
		creator = update.creator
		case creator.class.to_s
		when "User"
			link_to(gravatar_for(creator), creator)
		when "Group"
			link_to(image_tag(creator.image_url), creator)
		end
	end
end