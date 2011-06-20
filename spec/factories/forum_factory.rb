Factory.define(:forum) do |f|
  f.group { Factory(:group) }
  f.title { Factory.next(:title) }
end