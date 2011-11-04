module UsersHelper
	def avatar_for(user, options = {})
		if user.image.blank? && user.email?
			gravatar_for(user)
		else
			image_tag(user.image_url, :class => 'left spaced')
		end
	end
	
  def gravatar_for(user, options = { :size => 50 })
    gravatar_image_tag(user.email, :alt => user.name, :title => user.name, :class => "left spaced", :gravatar => options)
  end
  
  def user_title_for(filter)
	 case filter
   when 'following'
     t('users.following')
   when 'followers'
     t('users.followers')
   else
     t('users.all')
   end
	end
	
	def user_path_for(filter)
	 case filter
    when 'following'
      following_users_path
    when 'uploaded'
      followers_users_path
    else
      users_path
    end
	end
end
