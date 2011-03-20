Factory.define( :user_document ) do |f|
  f.document { Factory(:document) }
	f.user { Factory(:user) }
end