CarrierWave.configure do |config|
  if Rails.env.development?
    config.storage = :file
    config.permissions = 0666
    config.directory_permissions = 0777
    config.ignore_integrity_errors = false
    config.ignore_processing_errors = false
    config.ignore_download_errors = false
  elsif Rails.env.test? or Rails.env.cucumber?
    config.root = Rails.root.join("spec", "support", "carrierwave")
    config.storage = :file
    config.enable_processing = false
  else
    config.storage = :file
  end
end
