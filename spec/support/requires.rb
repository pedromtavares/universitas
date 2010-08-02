require 'factory_girl_rails'


Factory.definition_file_paths = [ File.join(Rails.root, 'spec', 'factories') ]
Factory.find_definitions