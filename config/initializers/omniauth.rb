Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  # provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :twitter, "eHlj7MFloX5YI8jNFBPXKGLqf", "dTQdsO8Tv9CZZv3TuTEDGdydx0AuLELKBDH8NWd9kYQRALBJv8"
end
