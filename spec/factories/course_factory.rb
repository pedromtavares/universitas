Factory.define( :course ) do |f|
  f.name "Example Course"
  f.teacher {Factory(:user)}
end