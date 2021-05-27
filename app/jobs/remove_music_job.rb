class RemoveMusicJob < ApplicationJob
  queue_as :default

  def perform(user_id, playlist_id)
    # Recupera Infomrações do Banco de Dados
    user = User.find_by(id: user_id)
    playlist_app = Playlist.includes(:musics).find_by(id: playlist_id)

    # Recupera as informações do Usuário na API do spotify
    spotify_user = RSpotify::User.new(user.user_hash)
    
    # Compara as Musicas recentementes tocadas com as da Playlist
    latest_musics = spotify_user.recently_played
    ids_latest_musics = latest_musics.map(&:id)
    musics_of_playlist_app = playlist_app.musics.where(id_spotify: ids_latest_musics, sounded: false)
    tracks = RSpotify::Track.find(musics_of_playlist_app.map(&:id_spotify))

    #Recupera a playlist do Spotify 
    playlist_spotify = GetPlaylistService.new({hash: user.user_hash , id_playlist: playlist_id}).call
    playlist_spotify.remove_tracks!(tracks)

    # Altera as musicas para "Tocada"
    musics_of_playlist_app.map do |music|
      music.sounded = true
      music.save
    end
    
    RemoveMusicJob.set(wait: 200.seconds).perform_later(user_id, playlist_id)
  end
end
