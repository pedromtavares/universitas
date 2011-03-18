Factory.define( :group ) do |f|
  f.name "Example Group"
  f.leader {Factory(:user)}
end