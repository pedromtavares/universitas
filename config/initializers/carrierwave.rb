services = YAML::load_file(File.join(Rails.root, 'config', 'services.yml'))
if Rails.env.test?
	CarrierWave.configure do |config|
	 	config.storage = :file
    config.enable_processing = false
  end
elsif Rails.env.development?
	CarrierWave.configure do |config|
	 	config.storage = :file
  end	
else
	CarrierWave.configure do |config|
		config.storage = :s3
		config.cache_dir = "#{Rails.root}/tmp/uploads"
		config.s3_access_key_id = services['s3']['key']
	  config.s3_secret_access_key = services['s3']['secret']
	  config.s3_bucket = 'universitas'
		config.s3_headers = {"Content-Disposition" => "attachment;"}
	end
end