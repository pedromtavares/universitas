Factory.define(:topic) do |f|
  f.forum { Factory(:forum) }
  f.title { Factory.next(:title) }
end