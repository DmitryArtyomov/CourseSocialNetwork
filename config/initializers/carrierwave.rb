CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:     'AKIAJS3XAAR2HECMFSTQ',
    aws_secret_access_key: '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',
    region:                'eu-central-1'
  }
  config.fog_directory  = 'artyomovd'
  # config.fog_public     = false                          # optional, defaults to true
  config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" }
end
