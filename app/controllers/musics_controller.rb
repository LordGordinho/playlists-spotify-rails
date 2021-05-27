class MusicsController < ApplicationController
    def index
        @musics = Music.all
    end

    def show
        @tracks = RSpotify::Track.search(params[:q], limit: 15)
    end

    def new
        @music = Music.new
    end

    def create
        spotify_user = RSpotify::User.new(current_user.user_hash)

        track = RSpotify::Track.find(music_params[:id_spotify])
        
        if Playlist.find_by(id: music_params[:playlist_id]).musics.where(id_spotify: track.id).exists?
            return redirect_to musics_path 
        else
            AddMusicJob.perform_now(current_user.user_hash , music_params[:id_spotify], music_params[:playlist_id], current_user.id)
        end

        @music = Music.new(
            name: track.name,
            href: track.href,
            id_spotify: track.id,
            time: track.duration_ms,
            playlist_id: music_params[:playlist_id]
        )

        redirect_to musics_path if @music.save
    
    end

    def destroy
        @music = Music.find_by(id: params[:id])
        track_of_spotify =  RSpotify::Track.find(@music.id_spotify)
        playlist_spotify = GetPlaylistService.new({hash: current_user.user_hash , id_playlist: @music.playlist.id}).call
        
        if !(@music.sounded)
            playlist_spotify.remove_tracks!([track_of_spotify])
        end

        @music.destroy
        redirect_to musics_path
    end

    private
    def music_params
        params.require(:music).permit(:id_spotify, :playlist_id)
    end
end
