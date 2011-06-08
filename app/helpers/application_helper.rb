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
	
	def submit_button(small = false, options = {}, &block)
		klass = 'button '
		klass += ' small-button ' if small
		klass += options.delete(:class) if options[:class]
		content_tag(:button, {:type => 'submit', :class => klass}.merge(options), &block)
	end
	
	def link_to_icon(icon, title, *args)
		name = case icon
		when :add
			"plusthick"
		when :edit
			"pencil"
		when :remove
			"closethick"
		when :user
			"person"
		when :check
			"check"
		end
		link_to(*args) do
			content_tag(:span, "", :class => "ui-icon ui-icon-#{name}", :title => title)
		end
	end
end
