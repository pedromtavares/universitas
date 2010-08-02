
Given /I dump the body/ do
  puts '===='
  puts response.body
  puts '===='
end

Given /I print all (.+)/ do |model|
  model = model.singularize.capitalize.constantize
  puts model.all.inspect
end