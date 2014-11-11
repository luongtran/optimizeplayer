CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => 'AKIAJWDPNEZ6R5KHD26A',
    :aws_secret_access_key  => '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',
  }
  
  config.fog_directory  = 'pixelserve'
  config.fog_public     = true
  config.fog_attributes = { 'Cache-Control' => 'max-age=30000000' }
end