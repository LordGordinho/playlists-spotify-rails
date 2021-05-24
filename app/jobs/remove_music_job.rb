class RemoveMusicJob < ApplicationJob
  queue_as :default

  def perform(hash , music_id, playlist_id)
    spotify_user = RSpotify::User.new(hash)
    track = RSpotify::Track.find(music_id)

    spotify_user.remove_tracks!(track)

    track_find = Music.find_by(id_spotify: track.id)
    track_find.sounded = True
    track_find.save
  end
end
