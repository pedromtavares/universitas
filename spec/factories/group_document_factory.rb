Factory.define( :group_document ) do |f|
  f.document { Factory(:document) }
	f.group { Factory(:group) }
	f.sender { Factory(:user) }
	f.pending true
end