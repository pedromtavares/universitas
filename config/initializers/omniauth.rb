dev = {:tk => '2E3XJX8ZjO7uCh2Rc1ww', :ts => 'LwoCJ6gInn7DrzHABTIe0qVTHpGWNy3oePe4k2qII', :fk => "203263839708974", :fs => "4ec759f2cb74f07153aca964a98fd721"}
prod = {:tk => "xSPf7B76FUoAgYoLtskow" , :ts => "TuneZkXeact74LKVKcv3afX1eBiXktyUjhntraKFiw", :fk => "214819401876654", :fs => "6ee3943e5c3fd456e0ecbaebd55b8d1f"}
hash = Rails.env.production? ? prod : dev
Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, hash[:tk], hash[:ts] 
	provider :facebook, hash[:fk], hash[:fs] 
end