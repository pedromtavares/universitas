def create_object(factory_name,row)
  row.keys.each do |key|
      methods = key.to_s.split( '.' )
      next if methods.size == 1
      row[ methods.first ] ||= {}
      row[ methods.first ][methods.last] = row[key]
      row.delete( key )
    end
  Factory( factory_name, row )
end

Given /^the following (.+) exists:$/ do |factory_name, table|
  factory_name = factory_name.singularize.to_sym
  table.hashes.each { |row| create_object(factory_name,row) }
end