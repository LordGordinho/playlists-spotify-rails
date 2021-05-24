require 'rspotify/oauth'

Rails.application.config.middleware.use OmniAuth::Builder do
    OmniAuth.config.allowed_request_methods = [:post, :get]
    provider :spotify, "935dfb595cf043f2ad849f82be15e4e2", "e3f5a29e06fb4f779600aeb74dc64e50", scope: 'user-read-email playlist-modify-public playlist-modify-private user-library-read user-library-modify user-read-recently-played playlist-read-private playlist-read-collaborative'
end