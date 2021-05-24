class AddMusicJob < ApplicationJob
  queue_as :default

  def perform(hash , music_id, playlist_id)

    track = RSpotify::Track.find(music_id)

    RemoveMusicJob.set(wait: ( (track.duration_ms / 1000) + 10 ).seconds).perform_later(hash , music_id, playlist_id)

    spotify_user = RSpotify::User.new(hash)
    playlists_spotify = spotify_user.playlists

    playlist_spotify = playlists_spotify.map do |playlist|
        playlist if playlist.id == Playlist.find(playlist_id).id_spotify
    end

    playlist_spotify = playlist_spotify.reject(&:blank?)
    playlist_spotify = playlist_spotify[0]

    
    byebug 
    begin 
        playlist_spotify.add_tracks!([track])
    rescue RestClient::BadRequest 
        redirect_to '/auth/spotify'
    end
  end
end
