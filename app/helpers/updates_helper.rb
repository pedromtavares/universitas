module UpdatesHelper
	
	def render_update_content(update)
    target = update.target
		creator = update.creator
		result = if update.to_user?
			"#{t('updates.updated_status')} '#{h(update.custom_message)}'"
		elsif update.to_group_member?
			"#{t('updates.joined_group')} #{link_to(target.group, target.group)}"
    elsif update.to_user_document?
			"#{t('updates.user_document_added')} #{target.name}"
		elsif update.to_group_document?
			"#{t('updates.group_document_added')} #{target.name}"
		elsif update.to_post?
			"#{link_to(target.author, target.author)} #{t('updates.posted_topic')} #{link_to(target.topic, target.topic)}: '#{target.text.truncate(100)}'"
		elsif update.to_topic?
			"#{link_to(target.author, target.author)} #{t('updates.created_topic')} #{link_to(target, target)}: '#{target.text.truncate(100)}'"
		elsif update.to_group?
			if update.from_user?
				if update.custom_message?
					"#{t('updates.promoted_group')} #{link_to(target, target)} #{t('updates.promoted_message')} '#{h(update.custom_message)}'"
				else
    			"#{t('updates.created_group')} #{link_to(target, target)}"
				end
			else
		    "#{t('updates.group_status')} '#{update.custom_message}'"
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
	
	def render_preview(update)
	  target = update.target
		creator = update.creator
		result = if update.to_user?
			render :partial => 'shared/previews/status', :update => update
		elsif update.to_group_member?
			render :partial => 'shared/previews/group_member', :update => update
    elsif update.to_user_document?
			render :partial => 'shared/previews/user_document', :update => update
		elsif update.to_group_document?
			render :partial => 'shared/previews/group_document', :update => update
		elsif update.to_post?
			render :partial => 'shared/previews/post', :update => update
		elsif update.to_topic?
			render :partial => 'shared/previews/topic', :update => update
		elsif update.to_group?
			if update.from_user?
				if update.custom_message?
					render :partial => 'shared/previews/promote', :update => update
				else
				  render :partial => 'shared/previews/new_group', :update => update
				end
			else
		    render :partial => 'shared/previews/group_status', :update => update
			end
		end
		result.html_safe
	end
end