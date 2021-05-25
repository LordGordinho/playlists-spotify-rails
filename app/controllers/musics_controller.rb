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

        track = RSpotify::Track.find(music_params[:id_spotify])
        
        AddMusicJob.perform_now(current_user.user_hash , music_params[:id_spotify], music_params[:playlist_id])
   
        @music = Music.new(
            name: track.name,
            href: track.href,
            id_spotify: track.id,
            time: track.duration_ms,
            playlist_id: music_params[:playlist_id]
        )

        redirect_to musics_path if @music.save
    
    end

    private
    def music_params
        params.require(:music).permit(:id_spotify, :playlist_id)
    end
end
