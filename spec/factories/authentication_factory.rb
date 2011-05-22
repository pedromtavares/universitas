Factory.define( :authentication ) do |f|
  f.uid rand(100)
	f.provider "twitter"
	f.user {Factory(:user)}
end