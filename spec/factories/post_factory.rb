Factory.define(:post) do |f|
  f.topic { Factory(:topic) }
  f.text "Testing text"
	f.author { Factory(:user) }
end