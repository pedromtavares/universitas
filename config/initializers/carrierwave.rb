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
		config.s3_access_key_id = ENV['S3KEY']
	  config.s3_secret_access_key = ENV['S3SECRET']
	  config.s3_bucket = 'universitas'
		config.s3_headers = {"Content-Disposition" => "attachment;"}
	end
end