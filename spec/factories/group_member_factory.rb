Factory.define( :group_member ) do |f|
  f.user {Factory(:user)}
  f.group {Factory(:group)}
end