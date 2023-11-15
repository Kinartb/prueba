# Replace API_KEY and API_SECRET with the values you got from Twitter
Rails.application.config.middleware.use OmniAuth::Builder do
  OmniAuth.config.allowed_request_methods = [ :post, :get]
  provider :google_oauth2, '431116730321-pljlbsellu0dhvpvabr47tt8bu1csbcf.apps.googleusercontent.com', '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'
end