module DashboardHelper
	
	def render_update_content(update)
    target = update.target
		creator = update.creator
		result = if update.to_user?
			"#{t('dashboard.updated_status')} '#{h(update.custom_message)}'"
		elsif update.to_group_member?
			"#{t('dashboard.joined_group')} #{link_to(target.group, target.group)}"
    elsif update.to_user_document?
			"#{t('dashboard.user_document_added')} #{target.name}"
		elsif update.to_group_document?
			"#{t('dashboard.group_document_added')} #{target.name}"
		elsif update.to_post?
			"#{link_to(target.author, target.author)} #{t('dashboard.posted_topic')} #{link_to(target.topic, target.topic)}: '#{target.text.truncate(100)}'"
		elsif update.to_topic?
			"#{link_to(target.author, target.author)} #{t('dashboard.created_topic')} #{link_to(target, target)}: '#{target.text.truncate(100)}'"
		elsif update.to_group?
			if update.from_user?
				if update.custom_message?
					"#{t('dashboard.promoted_group')} #{link_to(target, target)} #{t('dashboard.promoted_message')} '#{h(update.custom_message)}'"
				else
    			"#{t('dashboard.created_group')} #{link_to(target, target)}"
				end
			else
		    "#{t('dashboard.group_status')} '#{update.custom_message}'"
			end
		end
		result.html_safe
  end

	def render_update_creator(update)
		creator = update.creator
		if update.from_user?
			link_to(avatar_for(creator), creator)
		else
			link_to(image_tag(creator.image_url, :alt => creator, :title => creator), creator)
		end
	end
	
	def update_creator(update)
		creator = update.creator.class.to_s.parameterize
		case update.target.class.to_s.parameterize
			when 'post'
				creator = 'forum'
			when 'topic'
				creator = 'forum'
		end 
		creator
	end
end