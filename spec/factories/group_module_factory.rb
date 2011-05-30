Factory.define( :group_module ) do |f|
  f.name "Test Module"
	f.description "Test"
  f.group {Factory(:group)}
end