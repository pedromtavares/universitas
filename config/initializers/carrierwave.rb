CarrierWave.configure do |config|
	config.storage = :s3
	puts ENV['S3KEY']
	puts ENV['S3SECRET']
	config.s3_access_key_id = ENV['S3KEY']
  config.s3_secret_access_key = ENV['S3SECRET']
  config.s3_bucket = 'universitas'
end