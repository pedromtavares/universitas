module ApplicationHelper
	
	def loading_icon
		image_tag('loading.gif', :class => 'loading none')
	end
	
	def on_each_provider(&block)
		Authentication::PROVIDERS.each(&block)
	end
	
	def full_page?
		!user_signed_in? && controller.controller_name != 'home'
	end
end
