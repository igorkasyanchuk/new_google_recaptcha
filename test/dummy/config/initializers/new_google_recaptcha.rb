if Object.const_defined?('NewGoogleRecaptcha')
  NewGoogleRecaptcha.setup do |config|
    config.site_key   = "6LfBqncUAAAAAAEpwtSx3rh0FsurqYnmkBVA0-MX"
    config.secret_key = "6LfBqncUAAAAAHmiRgYzEIieu5n3XiHRpBTWfDrC"
    config.minimum_score = 0.5
  end
end
