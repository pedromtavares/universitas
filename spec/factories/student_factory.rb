Factory.define( :student ) do |f|
  f.user {Factory(:user)}
  f.course {Factory(:course)}
	f.grade 0
end