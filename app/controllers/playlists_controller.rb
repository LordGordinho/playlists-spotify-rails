class PlaylistsController < ApplicationController
    before_action :authenticate_user!
    
    def index
        @playlist = Playlist.all
    end

    def new
        @playlist = Playlist.new
    end

    def create
        spotify_user = RSpotify::User.new(current_user.user_hash)

        begin 
            playlist_spotify = spotify_user.create_playlist!(playlist_params[:name], public: false, collaborative: true )
        rescue RestClient::BadRequest 
            redirect_to '/auth/spotify'
        end

        @playlist = current_user.playlists.build(name: playlist_params[:name], 
                                image_url: playlist_spotify.images, 
                                public: playlist_spotify.public , 
                                owner: playlist_spotify.owner.to_hash , 
                                href: playlist_spotify.href, 
                                uri: playlist_spotify.uri , 
                                path: playlist_spotify.path , 
                                id_spotify: playlist_spotify.id
                               )

        if @playlist.save
            redirect_to playlists_path
        end
    end

    private

    def playlist_params
        params.require(:playlist).permit(:name)
    end
end
