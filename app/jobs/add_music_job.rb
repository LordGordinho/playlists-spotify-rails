class AddMusicJob < ApplicationJob
  queue_as :default
  include HTTParty

  def perform(hash , music_id, playlist_id, user_id)

    track = RSpotify::Track.find(music_id)

    spotify_user = RSpotify::User.new(hash)
    playlists_spotify = spotify_user.playlists
    
    user_app = User.find_by(id: user_id)
    playlist_app = Playlist.find_by(id_spotify: playlist_id)

    if playlist_app.owner['id'] == user_app.id_spotify
      playlist_spotify = playlists_spotify.map do |playlist|
          playlist if playlist.id == Playlist.find(playlist_id).id_spotify
      end

      playlist_spotify = playlist_spotify.reject(&:blank?)
      playlist_spotify = playlist_spotify[0]
      
      begin 
          playlist_spotify.add_tracks!([track])
      rescue RestClient::BadRequest 
          redirect_to '/auth/spotify'
      end
    else
      token = spotify_user.to_hash["credentials"]["token"]
      uri = "https://api.spotify.com/v1/playlists/#{playlist_app.id_spotify}"

      headers = {
        "Authorization" => "Bearer #{token}"
      }

      url = "#{uri}/tracks?uris=#{track.uri}"

      HTTParty.post( url , headers: headers)
    end
  end
end
