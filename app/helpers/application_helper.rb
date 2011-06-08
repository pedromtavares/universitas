module ApplicationHelper
	
	def loading_icon
		image_tag('loading.gif', :class => 'loading none')
	end
	
	def on_each_provider(&block)
		Authentication::PROVIDERS.each(&block)
	end
	
	def full_page?
		!user_signed_in? && !['home', 'about'].include?(controller.controller_name)
	end
	
	def button_link_to(*args, &block)
		options = args.extract_options!
		klass = 'button '
		klass += ' small-button ' if options[:small]
		klass += options.delete(:class) if options[:class]
		options[:class] = klass
		args << options
		link_to(*args, &block)
	end
	
	def submit_button(options = {}, &block)
		klass = 'button '
		klass += ' small-button ' if options[:small]
		klass += options.delete(:class) if options[:class]
		content_tag(:button, {:type => 'submit', :class => klass}.merge(options), &block)
	end
	
	def icon_for(name)
		case name
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
			when :search
				"search"
			when :folder
				"folder-open"
			when :message
				"comment"
			when :star
				"star"
			when :reply
				"arrowreturnthick-1-e"
			when :cancel
				"cancel"
			when :key
				"key"
		end
	end
	
	def button_icon(icon, options = {})
		klass = "ui-icon ui-icon-#{icon_for(icon)} left spaced-right"
		klass += options.delete(:class) if options[:class]
		content_tag(:span, "", {:class => klass}.merge(options))
	end
	
	def link_to_icon(icon, title, *args)
		link_to(*args) do
			content_tag(:span, "", :class => "ui-icon ui-icon-#{icon_for(icon)}", :title => title)
		end
	end
	
	def button_to_icon(icon, text, path, options = {})
		klass = 'button '
		klass += options.delete(:class) if options[:class]
		link_to(path, options.merge(:class => klass)) do
			content_tag(:span, "", :class => "ui-icon ui-icon-#{icon_for(icon)} left spaced-right") + text
		end
	end
	
	def search_button
		submit_button(:small => true) do
    	button_icon(:search) +
      t('shared.search')
		end
	end
	
end
