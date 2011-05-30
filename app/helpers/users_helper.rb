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
end
