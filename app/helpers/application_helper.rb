module ApplicationHelper
	
	def loading_icon
		image_tag('loading.gif', :class => 'loading none')
	end
	
	def tip_icon
	  image_tag('lightbulb_32.png', :class => 'fl')
	end
	
	def render_sidebar
	  render :partial => 'sidebar'
	end
	
	def on_each_provider(&block)
		Authentication::PROVIDERS.each(&block)
	end
	
	def button_link_to(*args, &block)
		options = args.extract_options!
		color = 'gray'
		color = options.delete(:color) if options[:color]
		klass = "button button-#{color}"
		klass += options.delete(:class) if options[:class]
		options[:class] = klass
		args << options
		link_to(*args, &block)
	end
	
	# refer to forms.css file
	def action_button(label, action, options = {})
	  path = options.delete(:path) || 'javascript:void(0)'
	  link_to path, {:class => 'action-button-link'}.merge(options) do
	    content_tag(:button, {:class => 'button button-gray'}) do
  	    content_tag(:span, '', :class => action) + label
  	  end
	  end
	end
	
	def submit_button(options = {}, &block)
		klass = 'button button-gray fr'
		klass += options.delete(:class) if options[:class]
		content_tag(:button, {:type => 'submit', :class => klass}.merge(options), &block)
	end
	
	def search_button
		submit_button do
		  content_tag(:span, '', :class => "search") + 
      t('shared.search')
		end
	end
	
	# for more icons check out the bottom of http://jqueryui.com/themeroller/
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
			when :download
				"arrowthickstop-1-s"
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
	
end
