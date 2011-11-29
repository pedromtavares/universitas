module ApplicationHelper
  
  def partial(name, locals = {})
    render :partial => name.to_s, :locals => locals
  end
	
	def loading_icon
		image_tag('loading.gif', :class => 'loading none')
	end
	
	def tip_icon
	  image_tag('lightbulb_32.png', :class => 'fl')
	end
	
	def render_sidebar(from = nil)
	  from ? partial("#{from}/sidebar") : partial(:sidebar)
	end
	
	def preview_link(label, path, options = {})
	  klass = "activate-preview "
		klass += options.delete(:class) if options[:class]
	  link_to label, path, options.merge(:remote => true, :class => klass)
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
	  no_text = label.blank? ? 'no-text' : ''
	  klass = "action-button-link "
		klass += options.delete(:class) if options[:class]
	  link_to path, {:class => klass}.merge(options) do
	    content_tag(:button, {:class => "button button-gray #{no_text}"}) do
  	    content_tag(:span, '', :class => action) + label
  	  end
	  end
	end
	
	def action_link(label, action, options = {})
	  path = options.delete(:path) || 'javascript:void(0)'
	  no_text = label.blank? ? 'no-text' : ''
	  klass = "button button-gray #{no_text} "
		klass += options.delete(:class) if options[:class]
	  link_to path, {:class => klass}.merge(options) do
  	  content_tag(:span, '', :class => action) + label
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
end
