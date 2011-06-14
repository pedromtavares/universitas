services = YAML::load_file(File.join(Rails.root, 'config', 'services.yml'))
twitter = services['twitter'][Rails.env]
facebook = services['facebook'][Rails.env]
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, twitter['key'], twitter['secret'] 
	provider :facebook, facebook['key'], facebook['secret'],{:scope => 'email, offline_access', :client_options => {:ssl => {:ca_file => '/usr/lib/ssl/certs/ca-certificates.crt'}}} 
end