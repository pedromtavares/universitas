module PostsHelper
	def nested_posts(posts)
	  posts.map do |post, sub_posts|
	    render(post) + content_tag(:div, nested_posts(sub_posts), :class => "nested-posts")
	  end.join.html_safe
	end
	def textile_guide
		content_tag(:a, :href => "javascript:window.open('#{textile_path}','popup_window','height=400,width=600')") do
			t('topics.textile')
		end
	end
end