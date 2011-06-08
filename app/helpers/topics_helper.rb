module TopicsHelper
	def topic_path(topic)
		group_forum_topic_path(topic.forum.group, topic.forum, topic)
	end
end