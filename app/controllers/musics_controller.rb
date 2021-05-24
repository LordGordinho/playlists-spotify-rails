class MusicsController < ApplicationController
    def index
        
    end

    def show
        @tracks = RSpotify::Track.search(params[:q], limit: 15)
    end

    def new
        @music = Music.new
    end

    def create
        spotify_user = RSpotify::User.new(current_user.user_hash)
        playlists_spotify = spotify_user.playlists

        playlist_spotify = playlists_spotify.map do |playlist|
            playlist if playlist.id == Playlist.find(music_params[:playlist_id]).id_spotify
        end

        playlist_spotify = playlist_spotify.reject(&:blank?)
        playlist_spotify = playlist_spotify[0]

        track = RSpotify::Track.find(music_params[:id_spotify])

        if Playlist.find_by(id: music_params[:playlist_id]).musics.exists?
            AddMusicJob.set(wait: ((Playlist.find_by(id: music_params[:playlist_id]).musics.last.time/1000) - 5 ).seconds).perform_later(current_user.user_hash , music_params[:id_spotify], music_params[:playlist_id])
        else        
            AddMusicJob.perform_now(current_user.user_hash , music_params[:id_spotify], music_params[:playlist_id])
        end

        @music = Music.new(
            name: track.name,
            href: track.href,
            id_spotify: track.id,
            time: track.duration_ms,
            playlist_id: music_params[:playlist_id]
        )

        if @music.save
            redirect_to musics_path
        end
    end

    private
    def music_params
        params.require(:music).permit(:id_spotify, :playlist_id)
    end
end
