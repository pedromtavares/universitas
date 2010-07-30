require 'factory_girl_rails'


Factory.definition_file_paths = [ File.join(RAILS_ROOT, 'spec', 'factories') ]
Factory.find_definitions