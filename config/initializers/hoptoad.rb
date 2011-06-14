services = YAML::load_file(File.join(Rails.root, 'config', 'services.yml'))
HoptoadNotifier.configure do |config|
  config.api_key = services['hoptoad']
end
